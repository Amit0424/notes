import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/common/app_colors.dart';
import 'package:notes/common/app_vectors.dart';
import 'package:notes/screens/auth/providers/user_provider.dart';
import 'package:notes/screens/home/providers/todos_provider.dart';
import 'package:notes/screens/home/screen/notes.dart';
import 'package:notes/screens/home/screen/todos.dart';
import 'package:notes/screens/home/widgets/create_new_todo.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserData();
    Provider.of<TodosProvider>(context, listen: false).getTodos();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          dividerColor: Colors.black,
          labelColor: AppColors.primary,
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          tabs: <Widget>[
            Tab(
              icon: SvgPicture.asset(
                AppVectors.note,
                height: 30,
                width: 30,
                colorFilter: _tabController.index == 0
                    ? const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      )
                    : const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
              ),
            ),
            Tab(
              icon: SvgPicture.asset(
                AppVectors.todo,
                height: 35,
                width: 35,
                colorFilter: _tabController.index == 1
                    ? const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      )
                    : const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const <Widget>[
              Notes(),
              Todos(),
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        onPressed: () {
          if (_tabController.index == 0) {
            return;
          } else {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return const CreateNewTodo();
                });
          }
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
