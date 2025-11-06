import 'package:flutter/material.dart' hide Image;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../Utils/common.dart';
import '../services/ad_manager.dart';
import '../services/tmdb_api_service.dart';
import '../models/person.dart';
import '../models/movie.dart' show Image;
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/loading_widget.dart';

class PersonDetailsScreen extends StatefulWidget {
  final int personId;

  const PersonDetailsScreen({super.key, required this.personId});

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  PersonDetails? personDetails;
  List<Cast> movieCredits = [];
  List<Cast> tvCredits = [];
  List<Crew> crewCredits = [];
  List<Image> personImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonDetails();
  }

  Future<void> _loadPersonDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final results = await Future.wait([
        TMDBAPIService.getPersonDetails(personId: widget.personId.toString()),
        TMDBAPIService.getPersonCombinedCredits(
          personId: widget.personId.toString(),
        ),
        TMDBAPIService.getPersonImages(personId: widget.personId.toString()),
      ]);

      // Combine data
      final personData = results[0];
      final creditsData = results[1];
      final imagesData = results[2];

      // Parse credits
      final cast = (creditsData['cast'] ?? [])
          .map<Cast>((c) => Cast.fromJson(c))
          .toList();
      final crew = (creditsData['crew'] ?? [])
          .map<Crew>((c) => Crew.fromJson(c))
          .toList();

      // Separate movies and TV shows
      final movies = cast.where((c) => c.mediaType == 'movie').toList();
      final tvShows = cast.where((c) => c.mediaType == 'tv').toList();

      // Parse images
      final images = (imagesData['profiles'] ?? [])
          .map<Image>((i) => Image.fromJson(i))
          .toList();

      setState(() {
        personDetails = PersonDetails.fromJson(personData);
        movieCredits = movies;
        tvCredits = tvShows;
        crewCredits = crew;
        personImages = images;
        isLoading = false;
      });
    } catch (e) {
      // Keep showing loader and retry automatically
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _loadPersonDetails();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const LoadingWidget()
          : personDetails == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPersonHeader(),
                      _buildPersonInfo(),
                      _buildBiography(),
                      _buildMovieCredits(),
                      _buildTVCredits(),
                      _buildCrewCredits(),
                      _buildImages(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: personDetails!.profileUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(color: Colors.grey[800]),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.person, color: Colors.grey, size: 100),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPersonHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            personDetails!.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (personDetails!.alsoKnownAs != null &&
              personDetails!.alsoKnownAs!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              personDetails!.alsoKnownAs!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (personDetails!.knownForDepartment.isNotEmpty)
            Chip(
              label: Text(personDetails!.knownForDepartment),
              backgroundColor: Colors.blue.withOpacity(0.2),
              labelStyle: const TextStyle(color: Colors.blue),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          if (personDetails!.birthday != null)
            _buildInfoChip(Icons.cake, _formatDate(personDetails!.birthday!)),
          if (personDetails!.deathday != null)
            _buildInfoChip(
              Icons.celebration,
              'Died: ${_formatDate(personDetails!.deathday!)}',
            ),
          if (personDetails!.age > 0)
            _buildInfoChip(Icons.person, '${personDetails!.age} years old'),
          if (personDetails!.placeOfBirth.isNotEmpty)
            _buildInfoChip(Icons.location_on, personDetails!.placeOfBirth),
          if (personDetails!.imdbId.isNotEmpty)
            _buildInfoChip(Icons.link, 'IMDb'),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[800],
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }

  Widget _buildBiography() {
    if (personDetails!.biography == null || personDetails!.biography!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biography',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            personDetails!.biography!,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCredits() {
    if (movieCredits.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Movie Credits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movieCredits.length > 20 ? 20 : movieCredits.length,
            itemBuilder: (context, index) {
              final credit = movieCredits[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildCreditCard(credit),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTVCredits() {
    if (tvCredits.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'TV Show Credits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tvCredits.length > 20 ? 20 : tvCredits.length,
            itemBuilder: (context, index) {
              final credit = tvCredits[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildCreditCard(credit),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCrewCredits() {
    if (crewCredits.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crew Credits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...crewCredits.take(10).map((crew) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  crew.displayTitle,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${crew.job} • ${crew.department}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: Text(
                  crew.year,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                onTap: () {
                  if (crew.mediaType == 'movie' && crew.id > 0) {
                    if (Common.adsopen == "2") {
                      Common.openUrl();
                    }
                    AdManager().showInterstitialAd();
                    Navigator.pushNamed(
                      context,
                      '/movie-details',
                      arguments: crew.id,
                    );
                  } else if (crew.mediaType == 'tv' && crew.id > 0) {
                    if (Common.adsopen == "2") {
                      Common.openUrl();
                    }
                    AdManager().showInterstitialAd();
                    Navigator.pushNamed(
                      context,
                      '/tv-details',
                      arguments: crew.id,
                    );
                  }
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCreditCard(Cast credit) {
    return GestureDetector(
      onTap: () {
        if (credit.mediaType == 'movie') {
          if (Common.adsopen == "2") {
            Common.openUrl();
          }
          AdManager().showInterstitialAd();
          Navigator.pushNamed(context, '/movie-details', arguments: credit.id);
        } else if (credit.mediaType == 'tv') {
          if (Common.adsopen == "2") {
            Common.openUrl();
          }
          AdManager().showInterstitialAd();
          Navigator.pushNamed(context, '/tv-details', arguments: credit.id);
        }
      },
      child: Container(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: credit.posterUrl,
                width: 140,
                height: 190,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    width: 140,
                    height: 210,
                    color: Colors.grey[800],
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 140,
                  height: 210,
                  color: Colors.grey[800],
                  child: Icon(
                    credit.mediaType == 'movie' ? Icons.movie : Icons.tv,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              credit.displayTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (credit.character.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                credit.character,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              credit.year,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImages() {
    if (personImages.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Photos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: personImages.length,
            itemBuilder: (context, index) {
              final image = personImages[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: image.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.grey[800]),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (e) {
      return date;
    }
  }
}
