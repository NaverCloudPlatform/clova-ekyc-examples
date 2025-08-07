/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example

import android.os.Bundle
import android.view.Gravity
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatTextView
import androidx.appcompat.widget.Toolbar
import androidx.navigation.findNavController
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.onNavDestinationSelected
import androidx.navigation.ui.setupActionBarWithNavController
import com.google.android.material.appbar.AppBarLayout

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<AppBarLayout>(R.id.appbar_layout).outlineProvider = null
        setSupportActionBar(findViewById(R.id.toolbar))
        centerTitle()

        val navController = (supportFragmentManager.findFragmentById(R.id.nav_host_fragment) as? NavHostFragment)?.navController

        navController?.let {
            setupActionBarWithNavController(navController = it)
        }

        navController?.addOnDestinationChangedListener {controller, destination, arg ->
            supportActionBar?.apply {
                setHomeAsUpIndicator(R.drawable.icon_back)
                setDisplayShowCustomEnabled(true)
            }
        }

        navController?.addOnDestinationChangedListener {controller, destination, arg ->
            supportActionBar?.apply {
                if(destination.id == R.id.ekycMainSettingsFragment)
                    setHomeAsUpIndicator(R.drawable.icon_back_black)
                else
                    setHomeAsUpIndicator(R.drawable.icon_back)
                setDisplayShowCustomEnabled(true)
            }
        }

        window.apply {
            clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
        }
    }

    override fun onSupportNavigateUp() =
        findNavController(viewId = R.id.nav_host_fragment).navigateUp() || super.onSupportNavigateUp()


    override fun onOptionsItemSelected(item: MenuItem) =
        item.onNavDestinationSelected(navController = findNavController(viewId = R.id.nav_host_fragment)) ||  super.onOptionsItemSelected(item)

    private fun centerTitle() {
        val textViews = ArrayList<View>()
        window.decorView.findViewsWithText(textViews, title, View.FIND_VIEWS_WITH_TEXT)

        if (textViews.size > 0) {
            var appCompatTextView: AppCompatTextView? = null
            if (textViews.size == 1)
                appCompatTextView = textViews[0] as? AppCompatTextView
            else {
                for (v in textViews) {
                    if (v.parent is Toolbar) {
                        appCompatTextView = v as? AppCompatTextView
                        break
                    }
                }
            }
            if (appCompatTextView != null) {
                val params = appCompatTextView.layoutParams
                params.width = ViewGroup.LayoutParams.MATCH_PARENT
                appCompatTextView.layoutParams = params
                appCompatTextView.gravity = Gravity.CENTER
                appCompatTextView.textAlignment = View.TEXT_ALIGNMENT_CENTER
            }
        }
    }
}