import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

class AddSwitchAccountView extends StatefulWidget {
  const AddSwitchAccountView({super.key});

  @override
  State<AddSwitchAccountView> createState() => _AddSwitchAccountViewState();
}

class _AddSwitchAccountViewState extends State<AddSwitchAccountView> {
  final AddSwitchAccountCubit addSwitchAccountCubit = AddSwitchAccountCubit();

  @override
  void initState() {
    addSwitchAccountCubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSwitchAccountCubit, AddSwitchAccountLoadedState>(
      bloc: addSwitchAccountCubit,
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: !(state.isInitialLoading ?? true),
              replacement: const SizedBox.shrink(),
              child: Visibility(
                  visible: state.addAccount ?? (state.subAccountModelResult?.count ?? 0) < 1,
                  replacement: SwitchAccountView(addSwitchAccountCubit: addSwitchAccountCubit, state: state),
                  child: IgnorePointer(
                      ignoring: state.isLoading,
                      child: AddAccountView(
                        addSwitchAccountCubit: addSwitchAccountCubit,
                        state: state,
                      ))),
            ),
            Visibility(
              visible: state.isLoading,
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).height / 4,
                  width: MediaQuery.sizeOf(context).width,
                  child: const LoaderView()),
            )
          ],
        );
      },
    );
  }
}
