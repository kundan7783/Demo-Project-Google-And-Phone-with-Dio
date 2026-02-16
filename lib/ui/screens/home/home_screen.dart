import 'package:demo_phone_google_auth/bloc/users/user_state.dart';
import 'package:demo_phone_google_auth/bloc/users/user_event.dart';
import 'package:demo_phone_google_auth/bloc/users/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUserEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) {
          if (state is UserFailure) {
            context.goNamed('login');
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(FetchUserEvent());
              },
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(radius: 40),
                  Text(state.userData.name ?? ''),
                  Text(state.userData.email ?? ''),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

