/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.adapter

import ai.clova.eyed.api.ncp.data.DocumentResult
import ai.clova.eyed.api.ncp.data.Meta
import ai.clova.eyed.example.databinding.LayoutIdScanIcrRecyclerItemBinding
import ai.clova.eyed.example.R
import android.content.Context
import android.graphics.Color
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class IdCardIcrAdapter(private val context: Context) : RecyclerView.Adapter<IdCardIcrAdapter.RecyclerViewHolder>() {

    private var items = mutableMapOf<String, String?>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerViewHolder {
        val binding =
            LayoutIdScanIcrRecyclerItemBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )

        binding.cardFieldValue.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}

            override fun afterTextChanged(s: Editable?) {
                items[binding.cardFieldName.text.toString()] = s.toString()
            }

        })

        return RecyclerViewHolder(binding)
    }

    override fun onBindViewHolder(recyclerViewHolder: RecyclerViewHolder, position: Int) {
        val item = items.toList()[position]
        val isSerial = item.first == context.getString(R.string.id_scan_icr_serial_hint)
        recyclerViewHolder.setData(item, isSerial)
    }

    override fun getItemCount(): Int = items.size

    class RecyclerViewHolder(
        private val binding: LayoutIdScanIcrRecyclerItemBinding
    ) : RecyclerView.ViewHolder(binding.root) {


        fun setData(item: Pair<String, String?>, isSerial: Boolean) {
            if (isSerial) {
                binding.cardFieldName.text = binding.root.context.getString(R.string.id_scan_icr_serial_hint)
            } else {
                binding.cardFieldName.text = item.first
            }

            val edit = binding.cardFieldValue
            if (isSerial) {
                // Configure as serial input
                edit.inputType = android.text.InputType.TYPE_CLASS_NUMBER

                val value = item.second
                val placeholder = "123456789000"

                if (value.isNullOrEmpty()) {
                    edit.setText("")
                    edit.hint = placeholder
                    edit.setTextColor(Color.WHITE)
                } else {
                    edit.hint = ""
                    edit.setText(value)
                    edit.setTextColor(Color.WHITE)
                }

                edit.onFocusChangeListener = android.view.View.OnFocusChangeListener { _, hasFocus ->
                    if (hasFocus) {
                        if (edit.text.isNullOrEmpty()) {
                            edit.hint = ""
                        }
                    } else {
                        if (edit.text.isNullOrEmpty()) {
                            edit.hint = placeholder
                        }
                    }
                }
            } else if (item.second?.isNotEmpty() == true) {
                edit.setTextColor(Color.WHITE)
                edit.setText(item.second)
                edit.hint = ""
            } else {
                edit.setTextColor(Color.RED)
                edit.setText("인식 실패")
                edit.hint = ""
            }
            edit.isFocusableInTouchMode = true
        }
    }

    fun setAdapterItem(result: DocumentResult) {
        if (result.meta == Meta.SUCCESS) {
            val card = when (result.result?.inferDetailType) {
                "IC" -> result.result?.idCard?.result?.ic
                "DL" -> result.result?.idCard?.result?.dl
                "PP" -> result.result?.idCard?.result?.pp
                "AC" -> result.result?.idCard?.result?.ac
                else -> null
            }

            val itemList = ArrayList<Pair<String, String?>>()
            card?.forEach { field ->
                // Exclude serialNum from the main list; it will be shown as the top dedicated item
                if (field.key != "serialNum") {
                    itemList.add(Pair(field.key, field.value.firstOrNull()?.text))
                }
            }
            val sortedList = itemList.sortedBy { it.first }
            items.clear()
            // Put serial field first so it appears at the top and scrolls with the list
            val serialFromOcr = card?.get("serialNum")?.firstOrNull()?.text
            items[context.getString(R.string.id_scan_icr_serial_hint)] = serialFromOcr ?: ""
            items.putAll(sortedList)
        }
    }

    fun getAdapterItem():List<Pair<String, String?>> {
        return items.toList()
    }

    fun getSerialNumber(): String? {
        val key = context.getString(R.string.id_scan_icr_serial_hint)
        return items[key]
    }
}
