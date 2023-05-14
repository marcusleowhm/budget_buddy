enum MainRoutes { dashboard, statistics, ledger, balance, more }

enum SubRoutes { useredit, reportbug, addledger }

const routes = <Object, String> {
  MainRoutes.dashboard: 'dashboard',
  MainRoutes.statistics: 'statistics',
  MainRoutes.ledger: 'ledger',
  MainRoutes.balance: 'balance',
  MainRoutes.more: 'more',
  SubRoutes.useredit: 'useredit',
  SubRoutes.addledger: 'add',
  SubRoutes.reportbug: 'report',
};

const labels = <Object, String> {
  MainRoutes.dashboard: 'Dashboard',
  MainRoutes.statistics: 'Statistics',
  MainRoutes.ledger: 'Ledger',
  MainRoutes.balance: 'Balance',
  MainRoutes.more: 'More'
};