import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forum_app/state/member_model.dart';
import 'package:provider/provider.dart';

class MemberProfile extends StatefulWidget {
  final String userId;
  const MemberProfile({super.key, required this.userId});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double totalHeight = MediaQuery.sizeOf(context).height;
    final double sliverToBoxAdapterMaxHeight = totalHeight * 0.3;
    final double sliverAppBarHeight = totalHeight * 0.1;
    return ChangeNotifierProvider(
      create: (_) => MemberModel(userId: widget.userId),
      child: Consumer<MemberModel>(
        builder: (context, provider, child) {
          if (provider.member == null) {
            return const CircularProgressIndicator();
          }
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  height: totalHeight / 2,
                  width: MediaQuery.sizeOf(context).width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      provider.member!.avatar != null
                          ? Image.network(
                              provider.member!.avatar!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'lib/assets/defaultAvatar.png',
                              fit: BoxFit.cover,
                            ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomScrollView(
                  slivers: <Widget>[
                    SliverLayoutBuilder(
                        builder: (BuildContext context, constraints) {
                      double scrollOffset = constraints.scrollOffset;
                      bool showWhiteBackground = scrollOffset >=
                          sliverToBoxAdapterMaxHeight - sliverAppBarHeight;
                      if (showWhiteBackground) {
                        return SliverAppBar(
                            backgroundColor: Colors.white,
                            expandedHeight: totalHeight * 0.23,
                            floating: false,
                            pinned: true,
                            elevation: 0,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Row(children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: provider.member!.avatar !=
                                          null
                                      ? NetworkImage(provider.member!.avatar!)
                                      : const AssetImage(
                                              'lib/assets/defaultAvatar.png')
                                          as ImageProvider,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  provider.member!.username,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                              ]),
                            ));
                      }
                      return SliverAppBar(
                        backgroundColor: Colors.transparent,
                        expandedHeight: totalHeight * 0.25,
                        floating: false,
                        pinned: true,
                        elevation: 0,
                        forceMaterialTransparency: true,
                        flexibleSpace: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double percent =
                              (constraints.maxHeight - kToolbarHeight) /
                                  (totalHeight * 0.25 - kToolbarHeight);
                          double scaleFactor = 0.3 + 0.7 * percent;
                          double verticalOffset = (1.0 - percent) * 150;

                          return FlexibleSpaceBar(
                            background: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..scale(scaleFactor)
                                    ..translate(0.0, -verticalOffset),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 46,
                                      backgroundImage: provider
                                                  .member!.avatar !=
                                              null
                                          ? NetworkImage(
                                              provider.member!.avatar!)
                                          : const AssetImage(
                                                  'lib/assets/defaultAvatar.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: totalHeight * 0.17,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(provider.member!.username,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 28, color: Colors.white)),
                                ),
                                SizedBox(
                                  height: totalHeight * 0.04,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text('+ Follow',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(thickness: 0.2),
                            Row(
                              children: [
                                const Text('Followings',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white60)),
                                const SizedBox(width: 4),
                                Text(
                                    provider.member!.followingsCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white60)),
                                const SizedBox(width: 8),
                                const Text('Followers',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white60)),
                                const SizedBox(width: 4),
                                Text(provider.member!.followersCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white60)),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 50.0,
                        maxHeight: 50.0,
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: '动态'),
                              Tab(text: 'Bookmarks')
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Container(
                        color: Colors.white,
                        child: TabBarView(
                          controller: _tabController,
                          children: const <Widget>[
                            Center(child: Text('用户动态内容')),
                            Center(child: Text('Bookmarks Contents')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
