import 'package:flutter/material.dart';
import '../core/api.dart';
import '../models/ficha.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  List<FichaResumen> _items = [];
  String _q = '';
  int _page = 1;
  final int _pageSize = 20;
  bool _loading = false;
  bool _noMore = false;

  @override
  void initState() {
    super.initState();
    _load(reset: true);

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200 &&
          !_loading &&
          !_noMore) {
        _load();
      }
    });
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading || (_noMore && !reset)) return;
    setState(() => _loading = true);

    try {
      if (reset) {
        _page = 1;
        _noMore = false;
        _items = [];
      }

      final raw = await Api.fichas(search: _q, page: _page, pageSize: _pageSize);
      final chunk = raw.map((e) => FichaResumen.fromJson(e)).toList();

      setState(() {
        _items.addAll(chunk);
        if (chunk.length < _pageSize) _noMore = true;
        _page += 1;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando fichas: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fichas médicas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o identificación…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _q.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _q = '';
                          _load(reset: true);
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (v) {
                _q = v.trim();
                _load(reset: true);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _load(reset: true),
              child: ListView.separated(
                controller: _scrollCtrl,
                itemCount: _items.length + (_loading || !_noMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  if (i >= _items.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: _noMore
                            ? const Text('No hay más resultados')
                            : const CircularProgressIndicator(),
                      ),
                    );
                  }

                  final f = _items[i];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        f.nombreCompleto.isNotEmpty ? f.nombreCompleto[0] : '?',
                      ),
                    ),
                    title: Text(f.nombreCompleto),
                    subtitle: Text(
                      '${f.numeroIdentificacion} • Ficha: ${f.numeroFicha ?? '-'}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Edad', style: TextStyle(fontSize: 11)),
                        Text('${f.edad ?? '--'}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/detalle', arguments: f.id);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
