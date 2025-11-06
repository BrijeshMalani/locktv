class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imageUrl; // Optional movie/TV show poster

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.imageUrl,
  });
}

class QuizSet {
  final int setId;
  final List<QuizQuestion> questions;

  QuizSet({required this.setId, required this.questions});
}

class QuizData {
  static List<QuizSet> get allSets => [
    QuizSet(
      setId: 1,
      questions: [
        QuizQuestion(
          question:
              'Which movie won the Academy Award for Best Picture in 2020?',
          options: [
            'Parasite',
            '1917',
            'Joker',
            'Once Upon a Time in Hollywood',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed the movie "Inception"?',
          options: [
            'Christopher Nolan',
            'Steven Spielberg',
            'Martin Scorsese',
            'Quentin Tarantino',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show is known for the phrase "Winter is Coming"?',
          options: [
            'Game of Thrones',
            'The Walking Dead',
            'Breaking Bad',
            'Stranger Things',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the highest-grossing movie of all time?',
          options: [
            'Avatar',
            'Avengers: Endgame',
            'Titanic',
            'Star Wars: The Force Awakens',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which actor played Tony Stark in the Marvel Cinematic Universe?',
          options: [
            'Robert Downey Jr.',
            'Chris Evans',
            'Chris Hemsworth',
            'Mark Ruffalo',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional continent in "Game of Thrones"?',
          options: ['Westeros', 'Middle-earth', 'Narnia', 'Hogwarts'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the song "My Heart Will Go On"?',
          options: ['Titanic', 'The Bodyguard', 'Dirty Dancing', 'Ghost'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the Joker in "The Dark Knight"?',
          options: [
            'Heath Ledger',
            'Joaquin Phoenix',
            'Jack Nicholson',
            'Jared Leto',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a chemistry teacher turned meth manufacturer?',
          options: ['Breaking Bad', 'Better Call Saul', 'Narcos', 'Ozark'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What year was the first "Star Wars" movie released?',
          options: ['1977', '1980', '1975', '1983'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie is about a man who ages backwards?',
          options: [
            'The Curious Case of Benjamin Button',
            'The Time Traveler\'s Wife',
            'Inception',
            'Interstellar',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "Pulp Fiction"?',
          options: [
            'Quentin Tarantino',
            'Martin Scorsese',
            'David Fincher',
            'Paul Thomas Anderson',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Eleven?',
          options: [
            'Stranger Things',
            'The Umbrella Academy',
            'Dark',
            'The OA',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional school in "Harry Potter"?',
          options: ['Hogwarts', 'Beauxbatons', 'Durmstrang', 'Ilvermorny'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2019?',
          options: ['Green Book', 'Roma', 'Black Panther', 'Bohemian Rhapsody'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character Walter White in "Breaking Bad"?',
          options: [
            'Bryan Cranston',
            'Aaron Paul',
            'Bob Odenkirk',
            'Jonathan Banks',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which movie features the quote "May the Force be with you"?',
          options: [
            'Star Wars',
            'Star Trek',
            'Guardians of the Galaxy',
            'The Matrix',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the main character in "The Matrix"?',
          options: ['Neo', 'Morpheus', 'Trinity', 'Agent Smith'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show is set in the fictional town of Hawkins?',
          options: [
            'Stranger Things',
            'Twin Peaks',
            'Riverdale',
            'The Vampire Diaries',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "The Shawshank Redemption"?',
          options: [
            'Frank Darabont',
            'Steven Spielberg',
            'Martin Scorsese',
            'David Fincher',
          ],
          correctAnswerIndex: 0,
        ),
      ],
    ),
    QuizSet(
      setId: 2,
      questions: [
        QuizQuestion(
          question: 'Which movie features the character Jack Dawson?',
          options: [
            'Titanic',
            'The Great Gatsby',
            'Casablanca',
            'Gone with the Wind',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional prison in "The Shawshank Redemption"?',
          options: [
            'Shawshank State Penitentiary',
            'Alcatraz',
            'Sing Sing',
            'Rikers Island',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Daenerys Targaryen?',
          options: [
            'Game of Thrones',
            'The Witcher',
            'Vikings',
            'The Last Kingdom',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Who played the character Hannibal Lecter in "The Silence of the Lambs"?',
          options: [
            'Anthony Hopkins',
            'Mads Mikkelsen',
            'Brian Cox',
            'Gary Oldman',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie is about a man who can see dead people?',
          options: ['The Sixth Sense', 'The Others', 'The Ring', 'The Grudge'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional company in "The Office" (US)?',
          options: [
            'Dunder Mifflin',
            'Initech',
            'Pied Piper',
            'Veridian Dynamics',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Andy Dufresne?',
          options: [
            'The Shawshank Redemption',
            'The Green Mile',
            'Escape from Alcatraz',
            'Cool Hand Luke',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "The Godfather"?',
          options: [
            'Francis Ford Coppola',
            'Martin Scorsese',
            'Steven Spielberg',
            'Alfred Hitchcock',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a group of friends living in Manhattan?',
          options: [
            'Friends',
            'How I Met Your Mother',
            'Seinfeld',
            'The Big Bang Theory',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional city in "The Dark Knight"?',
          options: ['Gotham City', 'Metropolis', 'Star City', 'Central City'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2018?',
          options: [
            'The Shape of Water',
            'Three Billboards Outside Ebbing, Missouri',
            'Get Out',
            'Dunkirk',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Who played the character Don Vito Corleone in "The Godfather"?',
          options: [
            'Marlon Brando',
            'Al Pacino',
            'Robert De Niro',
            'James Caan',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Sherlock Holmes?',
          options: ['Sherlock', 'Elementary', 'The Mentalist', 'Psych'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional planet in "Avatar"?',
          options: ['Pandora', 'Endor', 'Tatooine', 'Arrakis'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which movie features the quote "Here\'s looking at you, kid"?',
          options: [
            'Casablanca',
            'The Maltese Falcon',
            'Citizen Kane',
            'Gone with the Wind',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Who played the character Gollum in "The Lord of the Rings"?',
          options: [
            'Andy Serkis',
            'Ian McKellen',
            'Orlando Bloom',
            'Elijah Wood',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show is about a high school chemistry teacher?',
          options: [
            'Breaking Bad',
            'Better Call Saul',
            'The Good Doctor',
            'House',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional school in "The Breakfast Club"?',
          options: [
            'Shermer High School',
            'Ridgemont High',
            'East High School',
            'North Shore High',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Forrest Gump?',
          options: [
            'Forrest Gump',
            'Rain Man',
            'The Green Mile',
            'The Curious Case of Benjamin Button',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "Fight Club"?',
          options: [
            'David Fincher',
            'Christopher Nolan',
            'Quentin Tarantino',
            'Darren Aronofsky',
          ],
          correctAnswerIndex: 0,
        ),
      ],
    ),
    QuizSet(
      setId: 3,
      questions: [
        QuizQuestion(
          question:
              'Which movie features the character Maximus Decimus Meridius?',
          options: ['Gladiator', 'Troy', '300', 'Braveheart'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional town in "Twin Peaks"?',
          options: ['Twin Peaks', 'Hawkins', 'Riverdale', 'Mystic Falls'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Rick Grimes?',
          options: [
            'The Walking Dead',
            'Fear the Walking Dead',
            'Z Nation',
            'iZombie',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character John Wick?',
          options: [
            'Keanu Reeves',
            'Jason Statham',
            'Liam Neeson',
            'Tom Cruise',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2021?',
          options: [
            'Nomadland',
            'The Trial of the Chicago 7',
            'Mank',
            'Minari',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional universe in "The Matrix"?',
          options: ['The Matrix', 'The Grid', 'The Nexus', 'The Simulation'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a group of superheroes called "The Boys"?',
          options: [
            'The Boys',
            'The Umbrella Academy',
            'Doom Patrol',
            'Titans',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "Interstellar"?',
          options: [
            'Christopher Nolan',
            'Denis Villeneuve',
            'Ridley Scott',
            'James Cameron',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Elle Woods?',
          options: [
            'Legally Blonde',
            'Mean Girls',
            'Clueless',
            '10 Things I Hate About You',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional hospital in "Grey\'s Anatomy"?',
          options: [
            'Seattle Grace Hospital',
            'Chicago Med',
            'New Amsterdam',
            'County General',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Tyler Durden?',
          options: [
            'Fight Club',
            'American Psycho',
            'Taxi Driver',
            'American History X',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Who played the character Hermione Granger in "Harry Potter"?',
          options: [
            'Emma Watson',
            'Bonnie Wright',
            'Evanna Lynch',
            'Katie Leung',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Dexter Morgan?',
          options: ['Dexter', 'Hannibal', 'The Following', 'True Detective'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional city in "Blade Runner"?',
          options: ['Los Angeles', 'New York', 'Chicago', 'San Francisco'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2017?',
          options: [
            'Moonlight',
            'La La Land',
            'Arrival',
            'Manchester by the Sea',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character Tony Montana in "Scarface"?',
          options: ['Al Pacino', 'Robert De Niro', 'Joe Pesci', 'Ray Liotta'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a group of survivors on a deserted island?',
          options: ['Lost', 'The 100', 'The Walking Dead', 'The Last Ship'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional company in "Fight Club"?',
          options: [
            'Paper Street Soap Company',
            'Initech',
            'Dunder Mifflin',
            'Pied Piper',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Clarice Starling?',
          options: [
            'The Silence of the Lambs',
            'Hannibal',
            'Red Dragon',
            'Manhunter',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "The Departed"?',
          options: [
            'Martin Scorsese',
            'Quentin Tarantino',
            'David Fincher',
            'Christopher Nolan',
          ],
          correctAnswerIndex: 0,
        ),
      ],
    ),
    QuizSet(
      setId: 4,
      questions: [
        QuizQuestion(
          question: 'Which movie features the character Katniss Everdeen?',
          options: [
            'The Hunger Games',
            'Divergent',
            'The Maze Runner',
            'The Giver',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional school in "Riverdale"?',
          options: [
            'Riverdale High',
            'Hawkins High',
            'East High',
            'North Shore High',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Jon Snow?',
          options: [
            'Game of Thrones',
            'The Last Kingdom',
            'Vikings',
            'The Witcher',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Who played the character James Bond in "Casino Royale" (2006)?',
          options: [
            'Daniel Craig',
            'Pierce Brosnan',
            'Sean Connery',
            'Roger Moore',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2016?',
          options: [
            'Spotlight',
            'The Revenant',
            'Mad Max: Fury Road',
            'The Big Short',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional prison in "Prison Break"?',
          options: [
            'Fox River State Penitentiary',
            'Shawshank',
            'Alcatraz',
            'Rikers',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show is about a group of friends in New York?',
          options: [
            'Friends',
            'How I Met Your Mother',
            'Seinfeld',
            'Will & Grace',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "The Revenant"?',
          options: [
            'Alejandro González Iñárritu',
            'Guillermo del Toro',
            'Alfonso Cuarón',
            'Denis Villeneuve',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Dom Cobb?',
          options: [
            'Inception',
            'Interstellar',
            'The Prestige',
            'Shutter Island',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional city in "Sin City"?',
          options: ['Basin City', 'Gotham City', 'Metropolis', 'Central City'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Michael Scott?',
          options: [
            'The Office',
            'Parks and Recreation',
            'The Office (UK)',
            'Brooklyn Nine-Nine',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character The Joker in "Joker" (2019)?',
          options: [
            'Joaquin Phoenix',
            'Heath Ledger',
            'Jack Nicholson',
            'Jared Leto',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Ethan Hunt?',
          options: [
            'Mission: Impossible',
            'James Bond',
            'Jason Bourne',
            'John Wick',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional world in "The Lord of the Rings"?',
          options: ['Middle-earth', 'Westeros', 'Narnia', 'Hogwarts'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a group of superheroes in "The Umbrella Academy"?',
          options: [
            'The Umbrella Academy',
            'The Boys',
            'Doom Patrol',
            'Titans',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character Rocky Balboa?',
          options: [
            'Sylvester Stallone',
            'Arnold Schwarzenegger',
            'Jean-Claude Van Damme',
            'Chuck Norris',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2015?',
          options: [
            'Birdman',
            'Boyhood',
            'The Grand Budapest Hotel',
            'Whiplash',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional company in "The Office" (UK)?',
          options: ['Wernham Hogg', 'Dunder Mifflin', 'Initech', 'Pied Piper'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Walter White?',
          options: ['Breaking Bad', 'Better Call Saul', 'Narcos', 'Ozark'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "Django Unchained"?',
          options: [
            'Quentin Tarantino',
            'Martin Scorsese',
            'David Fincher',
            'Christopher Nolan',
          ],
          correctAnswerIndex: 0,
        ),
      ],
    ),
    QuizSet(
      setId: 5,
      questions: [
        QuizQuestion(
          question: 'Which movie features the character Luke Skywalker?',
          options: [
            'Star Wars',
            'Star Trek',
            'Guardians of the Galaxy',
            'The Matrix',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional school in "Glee"?',
          options: [
            'William McKinley High School',
            'East High School',
            'North Shore High',
            'Ridgemont High',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Sheldon Cooper?',
          options: [
            'The Big Bang Theory',
            'Young Sheldon',
            'Friends',
            'How I Met Your Mother',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character Iron Man in the MCU?',
          options: [
            'Robert Downey Jr.',
            'Chris Evans',
            'Chris Hemsworth',
            'Mark Ruffalo',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2014?',
          options: [
            '12 Years a Slave',
            'Gravity',
            'American Hustle',
            'The Wolf of Wall Street',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional city in "The Wire"?',
          options: ['Baltimore', 'New York', 'Chicago', 'Los Angeles'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a group of survivors in a zombie apocalypse?',
          options: [
            'The Walking Dead',
            'Fear the Walking Dead',
            'Z Nation',
            'iZombie',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "The Dark Knight"?',
          options: [
            'Christopher Nolan',
            'Tim Burton',
            'Joel Schumacher',
            'Zack Snyder',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Jack Sparrow?',
          options: [
            'Pirates of the Caribbean',
            'The Mummy',
            'Indiana Jones',
            'National Treasure',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'What is the name of the fictional hospital in "House"?',
          options: [
            'Princeton-Plainsboro Teaching Hospital',
            'Seattle Grace',
            'Chicago Med',
            'New Amsterdam',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Don Draper?',
          options: [
            'Mad Men',
            'The Sopranos',
            'Boardwalk Empire',
            'The Americans',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character Captain Jack Sparrow?',
          options: [
            'Johnny Depp',
            'Orlando Bloom',
            'Geoffrey Rush',
            'Keira Knightley',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie features the character Andy Sachs?',
          options: [
            'The Devil Wears Prada',
            'Legally Blonde',
            'Mean Girls',
            'Clueless',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional world in "The Chronicles of Narnia"?',
          options: ['Narnia', 'Middle-earth', 'Westeros', 'Hogwarts'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'Which TV show is about a group of friends in a coffee shop?',
          options: [
            'Friends',
            'How I Met Your Mother',
            'Seinfeld',
            'The Big Bang Theory',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who played the character Captain America in the MCU?',
          options: [
            'Chris Evans',
            'Robert Downey Jr.',
            'Chris Hemsworth',
            'Mark Ruffalo',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which movie won Best Picture in 2013?',
          options: ['Argo', 'Life of Pi', 'Lincoln', 'Silver Linings Playbook'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question:
              'What is the name of the fictional company in "The Office" (US)?',
          options: [
            'Dunder Mifflin',
            'Initech',
            'Pied Piper',
            'Veridian Dynamics',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Which TV show features the character Carrie Bradshaw?',
          options: [
            'Sex and the City',
            'Gossip Girl',
            'Desperate Housewives',
            'The Bold Type',
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          question: 'Who directed "Goodfellas"?',
          options: [
            'Martin Scorsese',
            'Francis Ford Coppola',
            'Quentin Tarantino',
            'David Fincher',
          ],
          correctAnswerIndex: 0,
        ),
      ],
    ),
  ];
}
