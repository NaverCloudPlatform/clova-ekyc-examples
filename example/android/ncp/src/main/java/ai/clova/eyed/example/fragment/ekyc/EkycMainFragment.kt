/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc


import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentEkycMainBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import android.os.Bundle
import android.view.*
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import java.util.concurrent.atomic.AtomicReference


class EkycMainFragment : Fragment() {

    private val binding = AtomicReference<FragmentEkycMainBinding>()


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")
        setHasOptionsMenu(true)

        binding.set(FragmentEkycMainBinding.inflate(inflater, container, false))
        return binding.get()?.root
    }


    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        menu.clear()
        inflater.inflate(R.menu.setting_menu, menu)

        super.onCreateOptionsMenu(menu, inflater)
    }


    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.settingMenu -> activity?.findNavController(R.id.nav_host_fragment)
                ?.navigate(R.id.ekycMainSettingsFragment)
        }
        return super.onOptionsItemSelected(item)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        binding.get()?.run {
            if(Configuration.faceInvokeUrl.isEmpty() || Configuration.faceSecretKey.isEmpty()) {
                Configuration.scenarioMode = Configuration.ScenarioMode.VERIFY

                idScanErrorCompare.isVisible = true
                idScanMainRadioCompare.isEnabled = false

                idScanErrorVerifyCompare.isVisible = true
                idScanMainRadioAll.isEnabled = false
            }

            when (Configuration.scenarioMode) {
                Configuration.ScenarioMode.VERIFY_COMPARE -> idScanMainRadioAll.isChecked = true
                Configuration.ScenarioMode.VERIFY -> idScanMainRadioVerify.isChecked = true
                Configuration.ScenarioMode.COMPARE -> idScanMainRadioCompare.isChecked = true
            }

            arrayOf(idScanMainRadioAll, idScanMainRadioVerify, idScanMainRadioCompare).forEach { radioButton ->
                radioButton.setOnClickListener {
                    when (radioButton) {
                        idScanMainRadioAll -> {
                            Configuration.scenarioMode = Configuration.ScenarioMode.VERIFY_COMPARE
                        }

                        idScanMainRadioVerify -> {
                            Configuration.scenarioMode = Configuration.ScenarioMode.VERIFY
                        }
                        idScanMainRadioCompare -> {
                            Configuration.scenarioMode = Configuration.ScenarioMode.COMPARE
                        }
                    }
                }
            }

            ekycButtonStart.setOnClickListener {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.navigate(R.id.idCardFrontFragment)
            }
        }
    }
}