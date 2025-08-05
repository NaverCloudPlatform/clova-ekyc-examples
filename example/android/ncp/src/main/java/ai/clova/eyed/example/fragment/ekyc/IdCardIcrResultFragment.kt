/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.api.ncp.NcpEkycApiManager
import ai.clova.eyed.api.ncp.data.DocumentResult
import ai.clova.eyed.api.ncp.data.Meta
import ai.clova.eyed.api.ncp.internal.core.verify
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.adapter.IdCardIcrAdapter
import ai.clova.eyed.example.databinding.FragmentIdScanIcrResultBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.runOnUiThread
import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.Button
import android.widget.TextView
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.lang.StringBuilder
import java.util.concurrent.atomic.AtomicReference


class IdCardIcrResultFragment : Fragment() {
    private val binding = AtomicReference<FragmentIdScanIcrResultBinding>()

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
        super.onDestroyView()
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")
        hideBackButton()
        binding.set(FragmentIdScanIcrResultBinding.inflate(inflater, container, false))
        dialog = Dialog(requireContext())

        initUI()

        return binding.get()?.root
    }


    override fun onAttach(context: Context) {
        super.onAttach(context)
        val callback = object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack(R.id.idCardFrontFragment, false)
            }
        }
        requireActivity().onBackPressedDispatcher.addCallback(this, callback)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

    }

    private fun initUI() {
        binding.get()?.run {
            idScanIcrHomeButton.setOnClickListener { button ->
                val inputManager =
                    requireActivity().getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                inputManager.hideSoftInputFromWindow(
                    requireActivity().currentFocus!!.windowToken,
                    InputMethodManager.HIDE_NOT_ALWAYS
                )

                val adapter = idScanIcrRecyclerview.adapter as IdCardIcrAdapter
                val itemList = adapter.getAdapterItem()

                itemList.forEach {
                    arrayOf(
                        Configuration.documentResult?.result?.idCard?.result?.ic,
                        Configuration.documentResult?.result?.idCard?.result?.dl,
                        Configuration.documentResult?.result?.idCard?.result?.pp,
                        Configuration.documentResult?.result?.idCard?.result?.ac,
                    ).forEach { card ->
                        card?.get(it.first)?.let { baseObjectList ->
                            if (baseObjectList.isEmpty()) {
                                baseObjectList.add(DocumentResult.Document.BaseObject(it.second.toString()))
                            } else {
                                baseObjectList.first().text = it.second.toString()
                            }
                        }
                    }
                }

                runOnUiThread {
                    idScanIcrResultLoadingLayer.isVisible = true
                    idScanIcrResultLoadingAnimation.apply {
                        isVisible = true
                        playAnimation()

                        button.apply {
                            isEnabled = false
                            background = resources.getDrawable(R.drawable.button_disable, null)
                        }
                    }
                }

                GlobalScope.launch(Dispatchers.IO) {
                    Configuration.documentResult?.let {
                        Configuration.verifyResult = apiManager.verify(
                            documentResult = it
                        )
                    }
                    runOnUiThread {
                        if (Configuration.verifyResult?.apiError?.code.equals("0022")) {
                            idScanIcrResultLoadingAnimation.isVisible = false
                            showDialog()
                        } else {
                            activity?.findNavController(R.id.nav_host_fragment)
                                ?.navigate(R.id.idCardVerifyResultFragment)
                        }
                    }
                }
            }

            idScanIcrRetryLayout.setOnClickListener {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack(R.id.idCardFrontFragment, false)
            }

            Configuration.documentResult?.let { icrResult ->
                when (icrResult.meta) {
                    Meta.SUCCESS -> {
                        val adapter = IdCardIcrAdapter().apply {
                            setAdapterItem(icrResult)
                        }
                        idScanIcrRecyclerview.adapter = adapter
                    }

                    else -> {
                        idScanIcrHomeButton.isVisible = false
                        idScanIcrErrorTextview.text = StringBuilder().apply {
                            appendLine(icrResult.apiError?.message)
                            append("Error Code : ${icrResult.apiError?.code}")
                        }
                    }
                }
            }
            Configuration.cardScanFrontResult?.let {
                idScanIcrImageview.setImageBitmap(it.originImage.getBitmap())
            }
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

    private fun hideBackButton() {
        (activity as? AppCompatActivity)?.supportActionBar?.setDisplayHomeAsUpEnabled(false)
    }
}
