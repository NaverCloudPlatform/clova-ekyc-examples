/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc


import ai.clova.eyed.card.ClovaIdCardDetectorOption
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.SettingsEkycMainBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.showToastMessage
import android.graphics.Typeface
import android.os.Bundle
import android.view.*
import android.view.inputmethod.InputMethodManager
import android.widget.Space
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.getSystemService
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import java.util.Random
import java.util.concurrent.atomic.AtomicReference


class EkycMainSettingsFragment : Fragment() {

    private val binding = AtomicReference<SettingsEkycMainBinding>()


    override fun onDestroyView() {
        (requireActivity() as? AppCompatActivity)?.supportActionBar?.apply {
            setDisplayShowCustomEnabled(false)
            setDisplayShowTitleEnabled(true)
            customView = TextView(context).apply {
                text = getString(R.string.string_null)
            }
        }

        (activity as? AppCompatActivity)?.findViewById<Space>(R.id.right_space)?.visibility =
            View.GONE

        super.onDestroyView()
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")
        binding.set(SettingsEkycMainBinding.inflate(inflater, container, false))

        return binding.get()?.root
    }


    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        menu.clear()
        super.onCreateOptionsMenu(menu, inflater)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        (activity as? AppCompatActivity)?.findViewById<Space>(R.id.right_space)?.visibility =
            View.VISIBLE

        (requireActivity() as? AppCompatActivity)?.supportActionBar?.apply {
            setDisplayShowCustomEnabled(true)
            setDisplayShowTitleEnabled(false)
            customView = TextView(context).apply {
                text = getString(R.string.ekyc_settings_name)
                textSize = 17f
                setTypeface(null, Typeface.BOLD)
                context?.let { context ->
                    setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.black
                        )
                    )
                }
            }
            customView.layoutParams.width = ViewGroup.LayoutParams.MATCH_PARENT
            customView.textAlignment = View.TEXT_ALIGNMENT_CENTER
        }

        binding.get()?.run {
            ekycSettingsSimilarityEdittext.setText(Configuration.similarityThreshold.toString())
            ekycSettingsDocumentUrlEdittext.setText(Configuration.idCardInvokeUrl)
            ekycSettingsDocumentKeyEdittext.setText(Configuration.idCardSecretKey)
            ekycSettingsCompareUrlEdittext.setText(Configuration.faceInvokeUrl)
            ekycSettingsCompareKeyEdittext.setText(Configuration.faceSecretKey)

            when (Configuration.ekycFaceLocation) {
               ClovaIdCardDetectorOption.IdFaceLocation.ANY_WHERE -> {
                    ekycSettingsFaceRadioButtonNoMatter.isChecked = true
                }

                ClovaIdCardDetectorOption.IdFaceLocation.LEFT -> {
                    ekycSettingsFaceRadioButtonLeft.isChecked = true
                }

                ClovaIdCardDetectorOption.IdFaceLocation.RIGHT -> {
                    ekycSettingsFaceRadioButtonRight.isChecked = true
                }
                else -> {}
            }

            when (Configuration.ekycSelectedMotion) {
                Configuration.Motion.EYE_BLINK -> {
                    ekycSettingsEyesExpressionButton.isChecked = true
                }

                Configuration.Motion.MOUTH_OPEN -> {
                    ekycSettingsMouthExpressionButton.isChecked = true
                }
                else -> {
                    ekycSettingsPoseExpressionButton.isChecked = true
                }
            }

            arrayOf(
                ekycSettingsMouthExpressionButton,
                ekycSettingsEyesExpressionButton,
                ekycSettingsPoseExpressionButton
            ).forEach { seletecdButton ->
                seletecdButton.setOnClickListener {
                    it.isSelected = true
                }
            }

            arrayOf(
                ekycSettingsFaceRadioButtonNoMatter,
                ekycSettingsFaceRadioButtonLeft,
                ekycSettingsFaceRadioButtonRight
            ).forEach { seletecdButton ->
                seletecdButton.setOnClickListener {
                    it.isSelected = true
                }
            }

            /** Set TEMPORARY */
            ekycDoneButton.setOnClickListener {
                Configuration.ekycSelectedMotion =
                    if (ekycSettingsMouthExpressionButton.isChecked) Configuration.Motion.MOUTH_OPEN
                    else if (ekycSettingsPoseExpressionButton.isChecked) if(Random().nextInt(2).mod(2) == 0) Configuration.Motion.HEAD_ROLL else Configuration.Motion.HEAD_SHAKE
                    else Configuration.Motion.EYE_BLINK

                Configuration.ekycFaceLocation =
                    if (ekycSettingsFaceRadioButtonNoMatter.isChecked) ClovaIdCardDetectorOption.IdFaceLocation.ANY_WHERE
                    else if (ekycSettingsFaceRadioButtonLeft.isChecked) ClovaIdCardDetectorOption.IdFaceLocation.LEFT
                    else ClovaIdCardDetectorOption.IdFaceLocation.RIGHT

                Configuration.idCardInvokeUrl = ekycSettingsDocumentUrlEdittext.text.toString()
                Configuration.idCardSecretKey = ekycSettingsDocumentKeyEdittext.text.toString()
                Configuration.faceInvokeUrl = ekycSettingsCompareUrlEdittext.text.toString()
                Configuration.faceSecretKey = ekycSettingsCompareKeyEdittext.text.toString()

                val similarityFloatvalue =
                    ekycSettingsSimilarityEdittext.text.toString().toFloatOrNull()

                if (similarityFloatvalue != null) {
                    Configuration.similarityThreshold = similarityFloatvalue
                    activity?.findNavController(R.id.nav_host_fragment)?.popBackStack(R.id.ekycMainFragment, true)
                    activity?.findNavController(R.id.nav_host_fragment)?.navigate(R.id.ekycMainFragment)
                } else {
                    (this@EkycMainSettingsFragment)
                        .showToastMessage("Please input float value.", Toast.LENGTH_SHORT)
                }
            }

            arrayOf(
                ekycSettingsSimilarityEdittext,
                ekycSettingsDocumentUrlEdittext,
                ekycSettingsDocumentKeyEdittext,
                ekycSettingsCompareUrlEdittext,
                ekycSettingsCompareKeyEdittext
            ).forEach {
                it.setOnFocusChangeListener { _, hasFocus ->
                    if (!hasFocus) {
                        context?.let { context ->
                            val inputMethodManager = getSystemService(
                                context,
                                InputMethodManager::class.java
                            )
                            inputMethodManager?.hideSoftInputFromWindow(
                                it.windowToken,
                                0
                            )
                        }
                    } else {
                        if(it != ekycSettingsSimilarityEdittext) {
                            it.setText("")
                        }
                    }
                }
            }
        }
    }
}