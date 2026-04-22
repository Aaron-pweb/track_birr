package com.example.track_birr.ui.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.track_birr.data.local.Expense
import com.example.track_birr.ui.viewmodels.HomeViewModel

@Preview
@Composable
fun HomeScreen(
    modifier: Modifier = Modifier,
    viewModel: HomeViewModel = hiltViewModel()
) {
    val expenses by viewModel.uiState.collectAsState()

    Column(modifier = modifier.padding(16.dp)) {
        Button(onClick = { 
            viewModel.addExpense(
                Expense(
                    amount = 150.0,
                    merchantName = "Test Merchant",
                    timestamp = System.currentTimeMillis(),
                    bankOrTelecom = "CBE",
                    isIncome = false
                )
            ) 
        }) {
            Text("Add Expense")
        }

        LazyColumn {
            items(expenses) { expense ->
                Text(text = "Spent ${expense.amount} at ${expense.merchantName}", modifier = Modifier.padding(8.dp))
            }
        }
    }
}
