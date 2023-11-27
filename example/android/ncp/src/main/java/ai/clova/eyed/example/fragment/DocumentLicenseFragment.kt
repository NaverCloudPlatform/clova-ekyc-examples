/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment


import ai.clova.eyed.api.ncp.data.Meta
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentLicenseMainBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.getJsonString
import ai.clova.eyed.example.utils.jsonParsing
import ai.clova.eyed.license.ClovaLicenseChecker
import android.app.Dialog
import android.os.Bundle
import android.view.*
import android.view.inputmethod.InputMethodManager
import android.widget.Button
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.concurrent.atomic.AtomicReference


class DocumentLicenseFragment : Fragment() {

    private val binding = AtomicReference<FragmentLicenseMainBinding>()

    private lateinit var dialog: Dialog

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")

        binding.set(FragmentLicenseMainBinding.inflate(inflater, container, false))
        dialog = Dialog(requireContext())
        return binding.get()?.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        initUi()

        binding.get()?.run {
            arrayOf(invokeUrlEdittext, secretKeyEdittext).forEach {
                it.setOnFocusChangeListener { _, hasFocus ->
                    if (!hasFocus) {
                        context?.let { context ->
                            val inputMethodManager = ContextCompat.getSystemService(
                                context,
                                InputMethodManager::class.java
                            )
                            inputMethodManager?.hideSoftInputFromWindow(
                                it.windowToken,
                                0
                            )
                        }
                    } else {
                        it.setText("")
                    }
                }
            }

            buttonDone.setOnClickListener {
                CoroutineScope(Dispatchers.Main).launch {
                    if (invokeUrlEdittext.text.isEmpty() || secretKeyEdittext.text.isEmpty()) {
                        errorDescreption.text = resources.getString(R.string.license_error_empty)
                    } else {
                        loadingAnimation.isVisible = true
                        loadingLayer.isVisible = true
                        loadingAnimation.playAnimation()

                        Configuration.idCardInvokeUrl = invokeUrlEdittext.text.toString()
                        Configuration.idCardSecretKey = secretKeyEdittext.text.toString()

                        val verifyResult = withContext(Dispatchers.IO) {
                            ClovaLicenseChecker.verify(
                                Configuration.idCardInvokeUrl,
                                Configuration.idCardSecretKey
                            )
                        }
                        loadingAnimation.isVisible = false
                        loadingLayer.isVisible = false

                        when (verifyResult.meta) {
                            Meta.SUCCESS -> {
                                errorDescreption.text = ""
                                showDialog()
                            }

                            Meta.SERVER_ERROR -> {
                                errorDescreption.text =
                                    resources.getString(R.string.license_error_verify)
                            }

                            Meta.FAILED -> {
                                errorDescreption.text =
                                    resources.getString(R.string.license_error_connection)
                            }
                        }
                    }
                }
            }
        }
    }

    private fun showDialog() {
        dialog.setContentView(R.layout.layout_license_alert)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setCancelable(false)

        dialog.findViewById<Button>(R.id.button_after).setOnClickListener {
            activity?.findNavController(R.id.nav_host_fragment)
                ?.navigate(R.id.mainFragment)
            dialog.dismiss()
        }
        dialog.findViewById<Button>(R.id.button_now).setOnClickListener {
            activity?.findNavController(R.id.nav_host_fragment)
                ?.navigate(R.id.compareLicenseFragment)
            dialog.dismiss()
        }
        dialog.show()
    }

    private fun initUi() {
        requestKey()

        binding.get()?.run {
            if(Configuration.idCardInvokeUrl.isNotEmpty()) {
                invokeUrlEdittext.setText(Configuration.idCardInvokeUrl)
            }
            if(Configuration.idCardSecretKey.isNotEmpty()) {
                secretKeyEdittext.setText(Configuration.idCardSecretKey)
            }
            errorDescreption.text = ""
        }
    }

    private fun requestKey() {
        kotlin.runCatching {
            context?.let {
                jsonParsing(getJsonString(context = it))
            }
        }.onFailure {
        }
    }
}