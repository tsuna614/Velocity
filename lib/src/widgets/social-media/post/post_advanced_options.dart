import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/post_model.dart';

class PostAdvancedOptions extends StatelessWidget {
  final MyPost post;
  const PostAdvancedOptions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: Text(AppLocalizations.of(context)!.savePost),
                  subtitle: Text(AppLocalizations.of(context)!
                      .saveThisPostToYourSavedPosts),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.rectangleXmark),
                  title: Text(AppLocalizations.of(context)!.hidePost),
                  subtitle:
                      Text(AppLocalizations.of(context)!.seeFewerPostsLikeThis),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.report),
                  title: Text(AppLocalizations.of(context)!.reportPost),
                  subtitle: Text(
                      AppLocalizations.of(context)!.reportThisPostToTheAdmin),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        if (post.userId == GlobalData.userId)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.trash),
                    title: Text(AppLocalizations.of(context)!.deletePost),
                    subtitle:
                        Text(AppLocalizations.of(context)!.deleteThisPost),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .areYouSureYouWantToDeleteThisPost),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<PostBloc>(context)
                                        .add(DeletePost(postId: post.postId));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(
                                                context)!
                                            .postHasBeenDeletedSuccessfully),
                                      ),
                                    );
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.delete),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
