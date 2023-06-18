// Routing
enum MainRoutes { dashboard, statistics, ledger, balance, more }

enum SubRoutes { useredit, reportbug, editLedger, addledger }

// Data input
enum TransactionType { income, expense, transfer }

enum InputType { add, edit }

// Period to filter
enum FilterPeriod {
  monthly,
  annual,
  weekly,
  oneMonth,
  threeMonth,
  sixMonth,
  oneYear,
  threeYear,
  fiveYear,
  tenYear,
}

// Recent transaction filter criteria
enum RecentTransactionFilterCriteria {
  transactionDate,
  createdDate,
  modifiedDate
}

// Charts
enum ChartDateFilterCriteria { sixMonth, fiveYear }

enum ChartAmountDisplayCriteria { gross, nett }
