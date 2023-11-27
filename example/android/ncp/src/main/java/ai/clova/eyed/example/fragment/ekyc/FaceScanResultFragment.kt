/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentFaceScanResultBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import android.os.Bundle
import android.view.*
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import java.util.concurrent.atomic.AtomicReference


class FaceScanResultFragment : Fragment() {

    private val binding = AtomicReference<FragmentFaceScanResultBinding>()


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
        hideBackButton(true)
        binding.set(FragmentFaceScanResultBinding.inflate(inflater, container, false))
        return binding.get()?.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        binding.get()?.run {
            Configuration.faceScanResult?.faceImage?.let {
                faceScanResultImageview.setImageBitmap(it)
            }
            faceScanResultRetryLayout.setOnClickListener {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack()
            }
            faceScanResultDoneButton.setOnClickListener {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.navigate(R.id.faceScanMotionFragment)
            }
        }
    }

    private fun hideBackButton(hide: Boolean) {
        if (hide) {
            (activity as? AppCompatActivity)?.supportActionBar?.setDisplayHomeAsUpEnabled(false)
        }
    }
}