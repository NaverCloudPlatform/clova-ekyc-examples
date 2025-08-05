/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.api.ncp.data.Meta
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentFaceMotionResultBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug


class FaceMotionResultFragment : Fragment() {

    private lateinit var binding: FragmentFaceMotionResultBinding

    override fun onDestroyView() {
        hideBackButton(false)
        super.onDestroyView()
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        debug(tag = TAG, message = "onCreateView")

        binding = FragmentFaceMotionResultBinding.inflate(inflater, container, false)
        hideBackButton(true)
        initUI()
        return binding.root
    }


    private fun initUI() {
        binding.motionResultButtonHome.setOnClickListener {
            activity?.findNavController(R.id.nav_host_fragment)
                ?.popBackStack(R.id.mainFragment, false)
        }

        binding.motionResultButtonRetry.setOnClickListener {
            if(Configuration.isDebugMode) {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack()
            }
            else {
                activity?.findNavController(R.id.nav_host_fragment)
                    ?.popBackStack(R.id.faceScanFragment, false)
            }
        }

        Configuration.facePreviewImage?.let { bitmap ->
            binding.motionResultPreviewLayer.setImageBitmap(bitmap)
        }

        updateResultImageView()
        updateResultText()
        updateInfoText()
    }


    private fun updateResultImageView() {
        val compareResult = Configuration.compareResult
        binding.motionResultImageView.setImageResource(
            when {
                compareResult == null -> R.drawable.icon_face_result_success
                (compareResult.result?.similarity ?: 0f) >= Configuration.similarityThreshold -> R.drawable.icon_face_result_success
                (compareResult.result?.similarity ?: 0f) >= Configuration.humanCheckThreshold -> R.drawable.icon_face_result_success
                else -> R.drawable.icon_face_result_fail
            }
        )
    }


    private fun updateResultText() {
        val compareResult = Configuration.compareResult
        binding.motionResultTextview.text = if (compareResult == null) {
            getString(R.string.motion_result_process_success)
        } else {
            if (compareResult.meta == Meta.SUCCESS) {
                if ((compareResult.result?.similarity ?: 0f) >= Configuration.similarityThreshold) {
                    getString(R.string.motion_result_process_success)
                } else if ((compareResult.result?.similarity
                        ?: 0f) >= Configuration.humanCheckThreshold
                ) {
                    getString(R.string.motion_result_process_maybe)
                } else {
                    getString(R.string.motion_result_process_fail)
                }
            } else {
                getString(R.string.motion_result_process_fail)
            }
        }
    }

    private fun updateInfoText() {
        val compareResult = Configuration.compareResult

        binding.motionResultInfoTextview.text = if (compareResult == null) {
            ""
        } else {
            if (compareResult.meta == Meta.SUCCESS) {
                if ((compareResult.result?.similarity ?: 0f) >= Configuration.similarityThreshold) {
                    ""
                } else if ((compareResult.result?.similarity ?: 0f) >= Configuration.humanCheckThreshold
                ) {
                    buildString {
                        append(getString(R.string.motion_result_process_desc_head))
                        append("%.2f".format(compareResult.result?.similarity))
                        append(getString(R.string.motion_result_process_desc_body_maybe))
                    }
                } else {
                    buildString {
                        append(getString(R.string.motion_result_process_desc_head))
                        append("%.2f".format(compareResult.result?.similarity))
                        append(getString(R.string.motion_result_process_desc_body_fail))
                    }
                }
            } else if (compareResult.meta == Meta.SERVER_ERROR) {
                getString(R.string.motion_result_dialog_response_error)
            } else {
                getString(R.string.motion_result_dialog_network_error)
            }
        }

        binding.motionResultSubInfoTextview.text = buildString {
            if (compareResult == null) {
            } else {
                if (compareResult.meta == Meta.SUCCESS && (compareResult.result?.similarity ?: 0f) >= Configuration.similarityThreshold
                ) {
                    append(getString(R.string.motion_result_process_similarity))
                    appendLine("%.2f".format(compareResult.result?.similarity))
                } else if (compareResult.meta != Meta.SUCCESS) {
                    appendLine(compareResult.apiError?.message)
                    append("Error Code : ${compareResult.apiError?.code}")
                }
            }
        }
    }


    private fun hideBackButton(hide: Boolean) {
        if (hide) {
            (activity as? AppCompatActivity)?.supportActionBar?.setDisplayHomeAsUpEnabled(false)
        }
    }
}
