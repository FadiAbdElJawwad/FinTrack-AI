import '../../../../core/constant/images_manager.dart';
import 'package:flutter/material.dart';
import '../../../../core/extension/app_sizes.dart';

class OnboardingModel {
  OnboardingModel({this.image, this.body, this.title});
  final String? image;
  final String? title;
  final String? body;
}

List<OnboardingModel> onboardingList(BuildContext context) {
  return [
    OnboardingModel(
      image: ImagesManager.onboarding_1,
      title: context.loc.onboardingTitle1,
      body: context.loc.onboardingBody1,
    ),
    OnboardingModel(
      image: ImagesManager.onboarding_2,
      title: context.loc.onboardingTitle2,
      body: context.loc.onboardingBody2,
    ),
    OnboardingModel(
      image: ImagesManager.onboarding_3,
      title: context.loc.onboardingTitle3,
      body: context.loc.onboardingBody3,
    ),
  ];
}
