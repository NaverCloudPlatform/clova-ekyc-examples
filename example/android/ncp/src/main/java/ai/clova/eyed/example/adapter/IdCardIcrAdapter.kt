/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.adapter

import ai.clova.eyed.api.ncp.data.DocumentResult
import ai.clova.eyed.api.ncp.data.Meta
import ai.clova.eyed.example.databinding.LayoutIdScanIcrRecyclerItemBinding
import android.graphics.Color
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class IdCardIcrAdapter : RecyclerView.Adapter<IdCardIcrAdapter.RecyclerViewHolder>() {

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
        recyclerViewHolder.setData(item)
    }

    override fun getItemCount(): Int = items.size

    class RecyclerViewHolder(
        private val binding: LayoutIdScanIcrRecyclerItemBinding
    ) : RecyclerView.ViewHolder(binding.root) {


        fun setData(item: Pair<String, String?>) {
            binding.cardFieldName.text = item.first

            if(item.second?.isNotEmpty() == true) {
                binding.cardFieldValue.setText(item.second)
            } else {
                binding.cardFieldValue.setTextColor(Color.RED)
                binding.cardFieldValue.setText("인식 실패")
            }
            binding.cardFieldValue.isFocusableInTouchMode = true
            binding.cardFieldValue.requestFocus()

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
            card?.map { field ->
                itemList.add(Pair(field.key, field.value.firstOrNull()?.text))
            }
            val sortedList = itemList.sortedBy { it.first }
            items.putAll(sortedList)
        }
    }

    fun getAdapterItem():List<Pair<String, String?>> {
        return items.toList()
    }
}
