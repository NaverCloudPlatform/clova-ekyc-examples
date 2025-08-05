/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.adapter

import ai.clova.eyed.api.ncp.data.Meta
import ai.clova.eyed.api.ncp.data.VerifyResult
import ai.clova.eyed.example.databinding.LayoutIdScanIcrVerifyItemBinding
import android.graphics.Color
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class IdCardVerifyAdapter : RecyclerView.Adapter<IdCardVerifyAdapter.RecyclerViewHolder>() {

    private var items = mutableMapOf<String, String?>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerViewHolder {
        val binding =
            LayoutIdScanIcrVerifyItemBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )


        return RecyclerViewHolder(binding)
    }

    override fun onBindViewHolder(recyclerViewHolder: RecyclerViewHolder, position: Int) {
        val item = items.toList()[position]
        recyclerViewHolder.setData(item)
    }

    override fun getItemCount(): Int = items.size

    class RecyclerViewHolder(
        private val binding: LayoutIdScanIcrVerifyItemBinding
    ) : RecyclerView.ViewHolder(binding.root) {


        fun setData(item: Pair<String, String?>) {
            binding.cardFieldName.text = item.first
            if(item.first == "Result" && item.second != "SUCCESS") {
                binding.cardFieldValue.setTextColor(Color.RED)
            } else {
                binding.cardFieldValue.setTextColor(Color.WHITE)
            }

            binding.cardFieldValue.setText(item.second)
            binding.cardFieldValue.isEnabled = false
        }
    }

    fun setAdapterItem(result: VerifyResult) {
        if (result.meta == Meta.SUCCESS) {
            val itemList = ArrayList<Pair<String, String?>>()
            result.info?.let { info ->
                itemList.add(Pair("Result", info.result))
                itemList.add(Pair("Type", info.inferType))
                itemList.add(Pair("Detail Type", info.inferDetailType))
                if (info.result != "SUCCESS") {
                    itemList.add(Pair("Error Code", info.code))
                    itemList.add(Pair("Message", info.message))
                }
            }
            items.putAll(itemList)
        }
    }
}
