// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/static/static.dart';
import '../../providers/_auth_provider.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/admin_service.dart';
import '../../models/admin/admin_create.dart';

class EditAdminView extends StatefulWidget {
  final String adminId;
  const EditAdminView({super.key, required this.adminId});

  @override
  State<EditAdminView> createState() => _EditAdminViewState();
}

class _EditAdminViewState extends State<EditAdminView> {
  // Field State Props
  bool _obscureText = true;
  late final _dateController = TextEditingController();

  // Add form controllers
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _adminService = AdminService();
  bool _isLoading = false;
  String token = '';
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _loadAdminData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminData() async {
    setState(() => _isLoading = true);
    try {
      final admin = await _adminService.fetchAdminById(widget.adminId, token);
      
      // Populate the form fields
      _usernameController.text = admin.username;
      _fullNameController.text = admin.fullName;
      _emailController.text = admin.email;
      // Note: We don't set the password as it's typically not returned from the API
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading admin: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final admin = AdminCreate(
        username: _usernameController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _adminService.updateAdmin(widget.adminId, admin, token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating admin: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _inputFieldStyle = AcnooInputFieldStyles(context);
    const _lg = 4;
    const _md = 6;

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 992,
          value: _SizeInfo(
            fonstSize: 12,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: _isLoading ? 
        const Center(child: CircularProgressIndicator()) :
        Form(
          key: _formKey,
          child: ListView(
            padding: _sizeInfo.padding,
            children: [
              ShadowContainer(
                headerText: 'Edit Admin',
                child: ResponsiveGridRow(
                  children: [
                    // Username
                    ResponsiveGridCol(
                      lg: _lg,
                      md: _md,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                        child: TextFieldLabelWrapper(
                          labelText: 'Username',
                          inputField: TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(hintText: 'Username'),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Username is required';
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    // Name
                    ResponsiveGridCol(
                      lg: _lg,
                      md: _md,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                        child: TextFieldLabelWrapper(
                          labelText: 'Name',
                          inputField: TextFormField(
                            controller: _fullNameController,
                            decoration: const InputDecoration(hintText: 'Name'),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Name is required';
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    // Email
                    ResponsiveGridCol(
                      lg: _lg,
                      md: _md,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                        child: TextFieldLabelWrapper(
                          labelText: 'Email',
                          inputField: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(hintText: 'Email'),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Email is required';
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    // Password Field
                    ResponsiveGridCol(
                      lg: _lg,
                      md: _md,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return TextFieldLabelWrapper(
                              labelText: 'Password',
                              inputField: TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                      () => _obscureText = !_obscureText,
                                    ),
                                    padding: EdgeInsetsDirectional.zero,
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    icon: Icon(
                                      _obscureText
                                          ? FeatherIcons.eye
                                          : FeatherIcons.eyeOff,
                                      size: 20,
                                    ),
                                  ),
                                  suffixIconConstraints: _inputFieldStyle.iconConstraints,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Update button
                    ResponsiveGridCol(
                      lg: 12,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateAdmin,
                          child: _isLoading 
                            ? const Center(child: CircularProgressIndicator())
                            : const Text('Update Admin'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsetsDirectional.all(24),
    this.innerSpacing = 24,
  });
}
