/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.api.ncp.data.Meta
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.adapter.IdCardVerifyAdapter
import ai.clova.eyed.example.databinding.FragmentIdScanVerifyResultBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import android.os.Bundle
import android.view.*
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import com.google.android.material.tabs.TabLayout
import com.google.gson.Gson
import java.lang.StringBuilder
import java.util.concurrent.atomic.AtomicReference


class IdCardVerifyResultFragment : Fragment() {
    private val binding = AtomicReference<FragmentIdScanVerifyResultBinding>()


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

        binding.set(FragmentIdScanVerifyResultBinding.inflate(inflater, container, false))
        hideBackButton(true)
        initUI()

        return binding.get()?.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

    }

    private fun initUI() {
        binding.get()?.run {
            idScanVerifyHomeButton.setOnClickListener {
                if (Configuration.scenarioMode == Configuration.ScenarioMode.VERIFY_COMPARE) {
                    activity?.findNavController(R.id.nav_host_fragment)
                        ?.navigate(R.id.faceScanFragment)
                } else {
                    activity?.findNavController(R.id.nav_host_fragment)
                        ?.popBackStack(R.id.mainFragment, false)
                }
            }

            if (Configuration.verifyResult?.info?.result != "SUCCESS" && Configuration.scenarioMode == Configuration.ScenarioMode.VERIFY_COMPARE) {
                idScanVerifyHomeButton.isVisible = false
            }

            if (Configuration.scenarioMode != Configuration.ScenarioMode.VERIFY_COMPARE) {
                idScanVerifyHomeButton.text = getString(R.string.id_scan_move_main)
            }

            idScanVerifyTabLayout.addOnTabSelectedListener(object :
                TabLayout.OnTabSelectedListener {
                override fun onTabSelected(tab: TabLayout.Tab?) {
                    when (tab?.position) {
                        0 -> {
                            idScanVerifyRecyclerview.isVisible = true
                            idScanVerifyTextview.isVisible = false
                        }

                        1 -> {
                            idScanVerifyRecyclerview.isVisible = false
                            idScanVerifyTextview.isVisible = true
                        }
                    }
                }

                override fun onTabUnselected(tab: TabLayout.Tab?) {
                    //Nothing
                }

                override fun onTabReselected(tab: TabLayout.Tab?) {
                    //Nothing
                }
            })

            idScanVerifyRetryLayout.setOnClickListener {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack()
            }

            Configuration.verifyResult?.let { verifyResult ->
                when (verifyResult.meta) {
                    Meta.SUCCESS -> {
                        val adapter = IdCardVerifyAdapter().apply {
                            setAdapterItem(verifyResult)
                        }
                        idScanVerifyRecyclerview.adapter = adapter
                        idScanVerifyTextview.text = Gson().toJson(verifyResult)
                    }
                    else -> {
                        idScanVerifyHomeButton.isVisible = false
                        idScanVerifyTabLayout.selectTab(idScanVerifyTabLayout.getTabAt(1))
                        idScanVerifyTabLayout.visibility = View.INVISIBLE

                        idScanVerifyTextview.apply {
                            text = StringBuilder().apply {
                                appendLine(verifyResult.apiError?.message)
                                append("Error Code : ${verifyResult.apiError?.code}")
                            }
                            setTextColor(resources.getColor(R.color.ClovaRed, null))
                            isVisible = true
                        }

                        idScanVerifyRecyclerview.isVisible = false
                    }
                }
            }
            Configuration.cardScanFrontResult?.let {
                idScanVerifyImageview.setImageBitmap(it.originImage.getBitmap())
            }
        }
    }

    private fun hideBackButton(hide: Boolean) {
        if (hide) {
            (activity as? AppCompatActivity)?.supportActionBar?.setDisplayHomeAsUpEnabled(false)
        }
    }
}
