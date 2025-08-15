import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? elevation;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? AppConstants.cardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
          child: child,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.white,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(text),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? placeholder;

  const NetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  }) : super(key: key);

  bool _isValidImageUrl(String url) {
    // Verificar si la URL es válida y no es una URL de ejemplo
    if (url.isEmpty ||
        url.contains('ejemplo.com') ||
        url.contains('placeholder.com') ||
        url.contains('via.placeholder.com')) {
      return false;
    }

    // Verificar si es una URL válida
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si la URL no es válida, mostrar el widget de error directamente
    if (!_isValidImageUrl(imageUrl)) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary.withOpacity(0.5),
            ),
            if (placeholder != null)
              Text(
                placeholder!,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary.withOpacity(0.5),
            ),
            if (placeholder != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  placeholder!,
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryText;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon,
    this.onRetry,
    this.retryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon ?? Icons.info_outline, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body1,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            CustomButton(text: retryText ?? 'Reintentar', onPressed: onRetry),
          ],
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWidget(
                imageUrl: imageUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.subtitle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: AppTextStyles.body2,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
