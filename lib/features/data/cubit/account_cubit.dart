import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/data/model/account.dart';
import 'package:budget_buddy/features/data/model/account_group.dart';
part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountState(accounts: [], accountGroups: []));

  void fetchAccountBalance() {
    //Create accounts here for now
    List<AccountGroup> newAccountGroups = [];
    AccountGroup bankAccountGroup = const AccountGroup(name: 'Bank Account');
    AccountGroup cashAccountGroup = const AccountGroup(name: 'Cash');
    AccountGroup cardAccountGroup = const AccountGroup(name: 'Card');
    AccountGroup investmentGroup = const AccountGroup(name: 'Investment');
    AccountGroup otherGroup = const AccountGroup(name: 'Others');
    newAccountGroups.add(bankAccountGroup);
    newAccountGroups.add(cashAccountGroup);
    newAccountGroups.add(cardAccountGroup);
    newAccountGroups.add(investmentGroup);
    newAccountGroups.add(otherGroup);

    List<Account> newAccounts = [];
    newAccounts.add(Account(group: bankAccountGroup, name: 'DBS', balance: 0.0));
    newAccounts.add(Account(group: bankAccountGroup, name: 'OCBC', balance: 0.0));
    newAccounts.add(Account(group: bankAccountGroup, name: 'Investment Capital', balance: 0.0));
    newAccounts.add(Account(group: cashAccountGroup, name: 'Cash', balance: 0.0));
    newAccounts.add(Account(group: cardAccountGroup, name: 'Citibank Premier Miles', balance: 0.0));
    newAccounts.add(Account(group: cardAccountGroup, name: 'Standard Chartered', balance: 0.0));
    newAccounts.add(Account(group: investmentGroup, name: 'CityIndex', balance: 0.0));
    newAccounts.add(Account(group: investmentGroup, name: 'TD Ameritrade', balance: 0.0));
    newAccounts.add(Account(group: otherGroup, name: 'Others', balance: 0.0));

    emit(AccountState(accounts: newAccounts, accountGroups: newAccountGroups));
  }
}
