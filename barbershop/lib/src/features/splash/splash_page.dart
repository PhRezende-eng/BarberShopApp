import 'dart:developer';

import 'package:barber_shop/src/core/ui/constants.dart';
import 'package:barber_shop/src/core/ui/helpers/messages.dart';
import 'package:barber_shop/src/features/auth/login/login_page.dart';
import 'package:barber_shop/src/features/splash/splash_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;

  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeigth => 100 * _scale;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _animationOpacityLogo = 1.0;
        _scale = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVMProvider, (_, state) {
      state.whenOrNull(error: (error, stackTrace) {
        log('Error ao validate login ', error: error, stackTrace: stackTrace);
        Messages.showError('Error ao validar o login', context);
        Navigator.pushNamedAndRemoveUntil(
            context, '/auth/login', (route) => false);
      }, data: (data) {
        switch (data) {
          case SplashState.initial:
            break;
          case SplashState.loggedADM:
            Navigator.pushNamedAndRemoveUntil(
                context, '/home/adm', (route) => false);
          case SplashState.loggedEmployee:
            Navigator.pushNamedAndRemoveUntil(
                context, '/home/employee', (route) => false);
          case SplashState.login:
            Navigator.pushNamedAndRemoveUntil(
                context, '/auth/login', (route) => false);
        }
      });
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(ImageConstants.backgroundChair),
            opacity: 0.2,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              curve: Curves.easeIn,
              opacity: _animationOpacityLogo,
              onEnd: onEnd,
              child: AnimatedContainer(
                width: _logoAnimationWidth,
                height: _logoAnimationHeigth,
                duration: const Duration(seconds: 1),
                curve: Curves.linearToEaseOut,
                child: Image.asset(
                  ImageConstants.imageLogo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onEnd() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const LoginPage();
        },
        settings: const RouteSettings(name: '/auth/login'),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }
}
