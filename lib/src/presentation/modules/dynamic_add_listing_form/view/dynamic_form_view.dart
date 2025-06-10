import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/presentation/common_widgets/app_bar.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing_form/cubit/add_listing_form_dynamic_cubit.dart';

class DynamicFormView extends StatefulWidget {
  final int formId;
  final int? itemId;

  const DynamicFormView({super.key, required this.formId,this.itemId});

  @override
  State<DynamicFormView> createState() => _DynamicFormViewState();
}

class _DynamicFormViewState extends State<DynamicFormView> {
  final AddListingFormDynamicCubit addListingFormDynamicCubit = AddListingFormDynamicCubit();

  @override
  void initState() {
    super.initState();
    addListingFormDynamicCubit.fetchFormData(widget.formId,listingId: widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddListingFormDynamicCubit, AddListingFormDynamicState>(
      bloc: addListingFormDynamicCubit,
      builder: (context, state) {
        if (state is AddListingFormDynamicLoadedState) {
          return _buildForm(state.listings, state.formValues);
        }
        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildForm(DynamicFormData? formDataList, Map<String, dynamic>? formValues) {
    return Scaffold(
      appBar: const MyAppBar(title: AppConstants.addListingTitleStr),
      body: formDataList != null
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formDataList.formName ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (formDataList.sections != null)
                  ...formDataList.sections!.map((section) => _buildSection(section, formValues)),
              ],
            )
          : const Center(child: Text('No form data available')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            print('Form Submitted: ${addListingFormDynamicCubit.formValues}');
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }

  Widget _buildSection(Sections section, Map<String, dynamic>? formValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(section.sectionName ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        if (section.inputFields != null)
          ...section.inputFields!.map((field) => _buildInputField(field, formValues)).toList(),
      ],
    );
  }

  Widget _buildInputField(InputFields field, Map<String, dynamic>? formValues) {
    final currentValue = formValues?[field.controlName] ?? '';

    switch (field.type) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
            onChanged: (value) => addListingFormDynamicCubit.updateFormValue(field.controlName ?? '', value),
          ),
        );

      case 'select':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: currentValue.isNotEmpty ? currentValue : null,
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
            items: (field.options ?? []).map((option) {
              return DropdownMenuItem(value: option.value, child: Text(option.label ?? ''));
            }).toList(),
            onChanged: (value) => addListingFormDynamicCubit.updateFormValue(field.controlName ?? '', value),
          ),
        );

      default:
        return Container();
    }
  }
}
