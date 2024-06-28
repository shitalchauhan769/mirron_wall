import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall_app/componets/network/provider/network_provider.dart';
import 'package:mirror_wall_app/componets/network/view/network_screen.dart';
import 'package:mirror_wall_app/screen/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? providerW;
  HomeProvider? providerR;
  InAppWebViewController? webView;
  PullToRefreshController? refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeProvider>().onProgress();
    refreshController = PullToRefreshController(
      onRefresh: () {
        webView!.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    providerW = context.watch<HomeProvider>();
    providerR = context.read<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Browser"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          providerR!.getBookmarkData();
                          showBookMarks();

                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("All Bookmarks"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          searchBox();
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.content_paste_search_outlined,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Search Engine"),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
      body: context.watch<NetworkProvider>().isInterNet
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: InAppWebView(
                        initialUrlRequest:
                            URLRequest(url: WebUri("https://www.google.com")),
                        onLoadStart: (controller, url) {
                          webView = controller;
                        },
                        onLoadStop: (controller, url) {
                          webView = controller;
                        },
                        pullToRefreshController: PullToRefreshController(
                          onRefresh: () {},
                        ),
                        onProgressChanged: (controller, progress) {
                          providerR!.checkLinearPrograss(progress / 100);
                          webView = controller;
                          if (progress == 100) {
                            refreshController?.endRefreshing();
                          }
                        })),

              ],
            )
          : const NetworkWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  webView!.loadUrl(
                      urlRequest:
                          URLRequest(url: WebUri("https://www.google.com")));
                },
                icon: const Icon(Icons.home),
                color: Colors.black,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () async{
                  String url = (await webView!.getUrl()).toString();
                  providerR!.setBookmarkData(url);

                },
                icon: const Icon(Icons.bookmark_add_outlined),
                color: Colors.black,
              ),
              label: "Bookmark"),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  webView!.goBack();
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
              ),
              label: "Bake"),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  webView!.goForward();
                },
                icon: const Icon(Icons.arrow_forward),
                color: Colors.black,
              ),
              label: "Forward"),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  webView!.reload();
                },
                icon: const Icon(Icons.refresh),
                color: Colors.black,
              ),
              label: "refresh"),
        ],
      ),
    );
  }

  void searchBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Column(
              children: [
                RadioListTile(
                  value: "Google",
                  groupValue: providerW!.isChoice,
                  onChanged: (value) {
                    providerR!.checkUi(value);
                    webView!.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri("https://www.google.com"),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  title: const Text("Google"),
                ),
                RadioListTile(
                  value: "Yahoo",
                  groupValue: providerW!.isChoice,
                  onChanged: (value) {
                    providerR!.checkUi(value);
                    webView!.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri("https://in.search.yahoo.com/?fr2=inr"),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  title: const Text("Yahoo"),
                ),
                RadioListTile(
                  value: "Bing",
                  groupValue: providerW!.isChoice,
                  onChanged: (value) {
                    providerR!.checkUi(value);
                    webView!.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri("https://www.bing.com"),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  title: const Text("Bing"),
                ),
                RadioListTile(
                  value: "Duck Duck Go",
                  groupValue: providerW!.isChoice,
                  onChanged: (value) {
                    providerR!.checkUi(value);
                    webView!.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri("https://duckduckgo.com"),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  title: const Text("Duck Duck Go"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
  void showBookMarks() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            Padding(padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(itemCount:providerR!.bookMark.length,itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            webView!.loadUrl(
                                urlRequest: URLRequest(url: WebUri(providerW!.bookMark[index])));
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(providerW!.bookMark[index]),));
                    },),
                  ),
                ],
              ),)
    );
  }
}

