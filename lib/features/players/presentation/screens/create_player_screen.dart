import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/players/presentation/widgets/create_player/create_player_app_bar.dart';

// TODO превратить в playerFormScreen чтобы ее переиспользовать в создании игрока и в редактровании
@RoutePage()
class CreatePlayerScreen extends StatelessWidget {
  const CreatePlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          CreatePlayerAppBar(
            onBackPressed: () {
              context.router.pop();
            },
          ),
          Text("Asd"),
        ],
      ),
    );
  }
}
