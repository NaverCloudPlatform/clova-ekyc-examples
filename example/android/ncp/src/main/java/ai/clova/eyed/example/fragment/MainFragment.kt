/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment


import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.view.*
import ai.clova.eyed.example.utils.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import ai.clova.eyed.example.BuildConfig
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.databinding.FragmentMainBinding
import java.util.concurrent.atomic.AtomicReference


class MainFragment : Fragment() {

    private val binding = AtomicReference<FragmentMainBinding>()


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setHasOptionsMenu(true)
        binding.set(FragmentMainBinding.inflate(inflater, container, false))
        return binding.get()?.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        updateUIComponents()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            activity?.run {
                requestPermissions(activity = this)
            }
        }
    }


    override fun onDestroyView() {
        binding.set(null)

        super.onDestroyView()
    }


    private fun requestPermissions(activity: Activity) {
        // All permissions to use
        val permissions = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU)
            arrayOf(
                Manifest.permission.CAMERA,
                Manifest.permission.READ_EXTERNAL_STORAGE
            ) else arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.READ_MEDIA_IMAGES
        )
        permissions.filter { permission ->
            activity.checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED
        }.toTypedArray().also { list ->
            if (list.isNotEmpty()) {
                registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { result ->
                    result.filter { !it.value }.also { denied ->
                        if (denied.isNotEmpty()) {
                            denied.keys.forEach { name ->
                                warn(tag = TAG, message = "Permission denied($name)")
                            }

                            activity.finishAndRemoveTask()
                        }
                    }
                }.launch(list)
            }
        }
    }


    private fun updateUIComponents() {
        binding.get()?.run {
            try {
                Class.forName("ai.clova.eyed.example.fragment.debug.QaMainFragment")
            } catch (e: ClassNotFoundException) {
                mainQaButton.visibility = View.GONE
            }

            mainEkycButton.setOnClickListener {
                Configuration.isDebugMode = false
                activity?.findNavController(R.id.nav_host_fragment)?.navigate(R.id.ekycMainFragment)
            }
            mainQaButton.setOnClickListener {
                Configuration.isDebugMode = true
                activity?.findNavController(R.id.nav_host_fragment)?.navigate(R.id.qaMainFragment)
            }

            mainVersion.run {
                setTypeface(typeface, Typeface.NORMAL)
                setTextIsSelectable(true)

                text = buildString {
                    append("v.")
                    appendLine(BuildConfig.VERSION_NAME)
                }
                visibility = View.VISIBLE
            }
        }
    }
}
