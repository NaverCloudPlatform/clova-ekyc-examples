/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.api.ncp.NcpEkycApiManager
import ai.clova.eyed.api.ncp.internal.core.document
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentIdScanTiltResultBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.runOnUiThread
import android.app.Dialog
import android.os.Bundle
import android.view.*
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.concurrent.atomic.AtomicReference


class IdCardScanTiltResultFragment : Fragment() {

    private val binding = AtomicReference<FragmentIdScanTiltResultBinding>()

    private lateinit var dialog: Dialog

    private val apiManager = NcpEkycApiManager {
        idCardInvokeUrl = Configuration.idCardInvokeUrl
        idCardSecretKey = Configuration.idCardSecretKey
    }


    override fun onDestroyView() {
        debug(tag = TAG, message = "onDestroyView")
        (requireActivity() as? AppCompatActivity)?.supportActionBar?.apply {
            setDisplayShowCustomEnabled(false)
            setDisplayShowTitleEnabled(true)
            customView = TextView(context).apply {
                text = getString(R.string.string_null)
            }
        }
        hideBackButton(false)
        super.onDestroyView()
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")

        binding.set(FragmentIdScanTiltResultBinding.inflate(inflater, container, false))
        dialog = Dialog(requireContext())
        return binding.get()?.root
    }


    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        menu.clear()
        hideBackButton(true)
        super.onCreateOptionsMenu(menu, inflater)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        binding.get()?.run {
            Configuration.cardScanTiltResult?.originImage?.let {
                idScanTiltResultImageview.setImageBitmap(it.getBitmap())
            }
            idScanTiltResultRetryLayout.setOnClickListener {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack()
            }
            idScanTiltResultDoneButton.setOnClickListener { button ->
                // Temporarily disable button UI
                button.isEnabled = false
                button.background = resources.getDrawable(R.drawable.button_disable, null)

                runOnUiThread {
                    val currentBinding = binding.get() ?: return@runOnUiThread
                    currentBinding.idScanTiltResultLoadingLayer.visibility = View.VISIBLE
                    currentBinding.idScanTiltResultLoadingAnimation.visibility = View.VISIBLE
                    currentBinding.idScanTiltResultLoadingAnimation.playAnimation()
                }

                GlobalScope.launch(Dispatchers.IO) {
                    // Run OCR on front image to detect document type
                    val frontBitmap = Configuration.cardScanFrontResult?.originImage?.getBitmap()
                    if (frontBitmap != null) {
                        Configuration.documentResult = apiManager.document(frontBitmap)
                    }

                    val isInvalidDomain = Configuration.documentResult?.apiError?.code.equals("0022")
                    val isPassport = Configuration.documentResult?.result?.idCard?.result?.idtype?.equals(
                        "Passport",
                        ignoreCase = true
                    ) == true

                    runOnUiThread {
                        val currentBinding = binding.get()
                        currentBinding?.idScanTiltResultLoadingAnimation?.visibility = View.INVISIBLE
                        currentBinding?.idScanTiltResultLoadingLayer?.visibility = View.INVISIBLE
                        if (isInvalidDomain) {
                            showDialog()
                        } else if (isPassport) {
                            activity?.findNavController(R.id.nav_host_fragment)
                                ?.navigate(R.id.idCardIcrResultFragment)
                        } else {
                            activity?.findNavController(R.id.nav_host_fragment)
                                ?.navigate(R.id.idCardBackFragment)
                        }
                    }
                }
            }
        }
    }


    private fun hideBackButton(hide: Boolean) {
        if (hide) {
            (activity as? AppCompatActivity)?.supportActionBar?.setDisplayHomeAsUpEnabled(false)
        }
    }

    private fun showDialog() {
        dialog.setContentView(R.layout.layout_invalid_domain_alert)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setCancelable(false)

        dialog.findViewById<Button>(R.id.button_confirm).setOnClickListener {
            activity?.findNavController(R.id.nav_host_fragment)
                ?.popBackStack(R.id.documentLicenseFragment, false)
            dialog.dismiss()
        }
        dialog.show()
    }
}
