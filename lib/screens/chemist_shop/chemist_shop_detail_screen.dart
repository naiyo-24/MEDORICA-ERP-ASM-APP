import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/chemist_shop/chemist_shop_contact_card.dart';
import '../../cards/chemist_shop/chemist_shop_description_card.dart';
import '../../cards/chemist_shop/chemist_shop_doctors_card.dart';
import '../../cards/chemist_shop/chemist_shop_header_card.dart';
import '../../models/chemist_shop.dart';
import '../../theme/app_theme.dart';

class ChemistShopDetailScreen extends StatefulWidget {
  final ChemistShop shop;

  const ChemistShopDetailScreen({
    super.key,
    required this.shop,
  });

  @override
  State<ChemistShopDetailScreen> createState() =>
      _ChemistShopDetailScreenState();
}

class _ChemistShopDetailScreenState extends State<ChemistShopDetailScreen> {
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
            ChemistShopHeaderCard(shop: widget.shop),
            
            // Description Card
            ChemistShopDescriptionCard(shop: widget.shop),
            
            // Doctors Card
            ChemistShopDoctorsCard(shop: widget.shop),
            
            // Contact Card
            ChemistShopContactCard(shop: widget.shop),
            
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
              widget.shop.name,
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
