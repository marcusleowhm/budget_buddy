part of 'account_cubit.dart';

class AccountState {
  const AccountState({
    required this.accounts,
    required this.accountGroups,
  });

  final List<Account> accounts;
  final List<AccountGroup> accountGroups;
}
