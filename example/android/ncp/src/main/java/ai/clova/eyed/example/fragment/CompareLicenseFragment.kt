/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment


import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentLicenseMainBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import android.os.Bundle
import android.view.*
import android.view.inputmethod.InputMethodManager
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import java.util.concurrent.atomic.AtomicReference


class CompareLicenseFragment : Fragment() {

    private val binding = AtomicReference<FragmentLicenseMainBinding>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")

        binding.set(FragmentLicenseMainBinding.inflate(inflater, container, false))
        return binding.get()?.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        initUi()

        binding.get()?.run {
            mainDescription.text = resources.getString(R.string.license_main_description_compare)

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
                if (invokeUrlEdittext.text.isEmpty() || secretKeyEdittext.text.isEmpty()) {
                    errorDescreption.text = resources.getString(R.string.license_error_empty)
                } else {
                    Configuration.faceInvokeUrl = invokeUrlEdittext.text.toString()
                    Configuration.faceSecretKey = secretKeyEdittext.text.toString()

                    activity?.findNavController(R.id.nav_host_fragment)
                        ?.navigate(R.id.mainFragment)
                }
            }
        }
    }

    private fun initUi() {
        binding.get()?.run {
            if (Configuration.faceInvokeUrl.isNotEmpty()) {
                invokeUrlEdittext.setText(Configuration.faceInvokeUrl)
            }
            if (Configuration.faceSecretKey.isNotEmpty()) {
                secretKeyEdittext.setText(Configuration.faceSecretKey)
            }
            errorDescreption.text = ""
        }
    }
}