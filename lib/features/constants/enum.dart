// Routing
enum MainRoutes { dashboard, statistics, ledger, balance, more }
enum SubRoutes { useredit, reportbug, editLedger, addledger }

// Data input
enum TransactionType { income, expense, transfer }
enum InputType { add, edit }

// Recent transaction filter criteria
enum RecentTransactionFilterCriteria { transactionDate, createdDate, modifiedDate }

// Charts
enum ChartDateFilterCriteria { threeMonth, sixMonth, fiveYear }
enum ChartAmountDisplayCriteria { gross, nett }