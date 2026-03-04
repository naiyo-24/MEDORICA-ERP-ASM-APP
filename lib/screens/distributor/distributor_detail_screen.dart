import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/distributor/distributor_contact_card.dart';
import '../../cards/distributor/distributor_description_card.dart';
import '../../cards/distributor/distributor_order_info_card.dart';
import '../../cards/distributor/dsitributor_header_card.dart';
import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorDetailScreen extends StatefulWidget {
  final Distributor distributor;

  const DistributorDetailScreen({
    super.key,
    required this.distributor,
  });

  @override
  State<DistributorDetailScreen> createState() =>
      _DistributorDetailScreenState();
}

class _DistributorDetailScreenState extends State<DistributorDetailScreen> {
  late ScrollController _scrollController;
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showAppBar) {
      setState(() => _showAppBar = true);
    } else if (_scrollController.offset <= 200 && _showAppBar) {
      setState(() => _showAppBar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAnimatedAppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Card
            DistributorHeaderCard(distributor: widget.distributor),
            
            // Order Info Card
            DistributorOrderInfoCard(distributor: widget.distributor),
            
            // Description Card
            DistributorDescriptionCard(distributor: widget.distributor),
            
            // Contact Card
            DistributorContactCard(distributor: widget.distributor),
            
            // Bottom Padding
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      backgroundColor: _showAppBar
          ? AppColors.white
          : AppColors.white.withAlpha(0),
      elevation: _showAppBar ? 2 : 0,
      leading: GestureDetector(
        onTap: () => GoRouter.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Iconsax.arrow_circle_left,
            color: AppColors.primary,
          ),
        ),
      ),
      title: _showAppBar
          ? Text(
              widget.distributor.name,
              style: AppTypography.h3.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      centerTitle: false,
    );
  }
}
