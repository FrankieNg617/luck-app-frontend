class ZodiacRelationshipDetail {
  const ZodiacRelationshipDetail({
    required this.label,
    required this.body,
  });

  final String label;
  final String body;
}

class ZodiacRelationshipDetailRepository {
  static final Map<String, Map<String, ZodiacRelationshipDetail>> _data = {
    "Aries": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'When you two first meet, it’s very easy for sparks to fly. You’re magnetically attracted to each other, and '
        'the relationship tends to develop quickly and intensely. The attraction between you is usually natural and '
        'effortless. As long as you clarify your feelings for each other, the passion between you can remain strong and lasting.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Aries, who love trying new things, are drawn to people who are just as energetic and driven as they are. '
        'Heading off to see the ocean tomorrow, then learning to surf together the day after — they love having someone by '
        'their side to experience all kinds of new adventures. Fellow fire signs, Leo and Sagittarius, easily hit it off '
        'with Aries right away.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Aries is the first of the 12 zodiac signs, full of confidence with a proactive and positive personality. In '
        'relationships, they tend to be the pursuer rather than the one being pursued. In intimate moments, Aries doesn’t '
        'particularly like expressing their emotions verbally; instead, they prefer pure and exciting physical connection. '
        'Even a simple gesture — like a partner’s hand brushing through their hair — can instantly captivate them, and they '
        'deeply enjoy that thrilling sensation.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'When there are trivial matters you don’t have the patience to deal with, Pisces may not enjoy handling them, '
        'but they’ll still reluctantly get them done. When you feel like complaining, Pisces will quietly listen. When you '
        'love being in the spotlight, Pisces will applaud and cheer for you from below the stage. Occasionally, you may '
        'think Pisces lack decisiveness, but people around you might feel that you’re taking advantage of them and still '
        'acting ungrateful. With your strong individualism, sometimes you don’t feel that anyone can truly become a partner '
        'who satisfies you.'
      ),
    },

    "Taurus": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'You two could truly be called a match made in heaven. Your values and outlooks are very similar — both of '
        'you seek a simple, stable life, dislike taking risks, and easily find emotional fulfillment. You get along '
        'extremely well, and the longer you’re together, the deeper your feelings grow — making it hard to part from one '
        'another. Your relationship is the kind that seeks steady growth within stability.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Taurus places great importance on their friendships. In return, they hope to receive attention from the '
        'friends they value. They also wish that those close to them can appreciate their stubborn side — or even share in '
        'their passionate devotion to the things they love. Loving and affectionate signs like Pisces and Cancer are '
        'especially well suited to Taurus.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Taurus’s approach to intimacy isn’t about chasing overt sexiness in bed; instead, they focus more on stimulation '
        'and awakening desire. From their experience, they’ve learned that sounds and physical touch play a very important role '
        'during lovemaking. They don’t actively pursue the “perfect” sexual partner, believing that doing so is a waste of '
        'time. Instead, they prefer to wait patiently for their own happiness and fulfillment to come their way.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'On the surface, Taurus may seem gentle, but they actually have a stubborn and prideful temper. Because they '
        'often cling to their own opinions, they may overlook others’ feelings in cooperation, which can leave them feeling '
        'isolated and without support. Virgo’s strengths in organization and planning make them highly compatible with you. '
        'When you refuse well-intentioned advice, Virgo’s rational analysis and empathetic communication can help you open '
        'your heart, accept others’ opinions at the right time, and enhance harmony in your interpersonal relationships.'
      ),
    },

    "Gemini": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'Both of you are full of modern flair and intellectual charm. Being together feels pleasant and comfortable, '
        'without being overly clingy. In many situations, your thoughts align naturally — you share strong chemistry and '
        'understanding without even needing to say much. You also make a very outgoing pair: versatile, colorful, and full '
        'of variety — a truly eye-catching combination.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Making friends and chatting are never difficult for sociable Geminis. With their sense of humor, there’s '
        'really only one type of person they dislike — boring people. Only when they’re with interesting individuals who '
        'are curious about life can Gemini feel energized and inspired, bringing out their rich creativity. Aries, Libra, '
        'and fellow Geminis tend to get along especially well with them.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'When it comes to sex, Gemini is very open-minded. They enjoy trying new things, and exploring different '
        'settings can be especially exciting for them. In addition, Gemini loves hearing a bit of “dirty talk.” They’re '
        'skilled at flirting and prefer to keep their intimate relationships dynamic and flexible. Basically, they truly '
        'enjoy making love.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'You and Aries are both intelligent and quick-witted, working at a similar pace. When reaching consensus and '
        'collaborating, one of your private amusements is making fun of those who aren’t very sharp. The creative ideas '
        'sparked by brainstorming between you and Aries often bring new possibilities. However, you’re not good at following '
        'through, and Aries lacks patience in execution. Unless you’re fortunate enough to have strong operational support '
        'backing you up, your cooperative relationship is unlikely to last long.'
      ),
    },

    "Cancer": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'When you first meet, you’ll immediately feel a sense of connection. The mutual understanding and appreciation '
        'between you will grow even stronger as your relationship deepens. If you meet after both having gone through life’s '
        'experiences, you’ll understand and commit to each other even more deeply — often knowing what the other is thinking '
        'without needing words. With such emotional and spiritual harmony, you can fully enjoy a mature and fulfilling love.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: '“A tough exterior hiding a fragile heart” perfectly describes Cancer. Cancers don’t easily trust others or '
        'open up emotionally — unless they meet friends who can offer unconditional care and empathy. Emotionally sensitive '
        'water signs such as Pisces and Scorpio are the ones most able to enter and understand Cancer’s delicate inner world.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Cancer is a creative and emotional lover, but before making love, they desire foreplay that is full of '
        'affection. Their sensitive mind allows them to easily please their partner and reach climax during intimacy.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'You and Taurus share the common traits of being gentle in your attitude toward others and preferring to '
        'plan ahead before taking action, following through step by step. You also have similar values when it comes to '
        'money, carefully considering your budget plans. As a result, when you reach mutual understanding, both sides can '
        'provide each other with a sense of security. As food lovers, when stress builds up, any dissatisfaction or '
        'complaints can be eased and digested together while enjoying a good meal.'
      ),
    },

    "Leo": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'When you two first meet, it’s very easy for sparks to fly. You’re magnetically attracted to each other, and '
        'the relationship tends to develop quickly and intensely. The attraction between you is usually natural and '
        'effortless. As long as you clarify your feelings for each other, the passion between you can remain strong and lasting.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Leos are very open and expressive in relationships, and in any social or entertainment setting, they naturally '
        'become the center of attention. However, after the excitement fades, Leos also long for quiet, heartfelt conversations '
        '— and this is where Aquarius becomes their ideal companion. Aquarius’s unique and innovative perspectives always feel fresh and fascinating to Leo.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Leo is known for their consistently powerful and passionate approach to intimacy. They use their natural '
        'charm to attract partners, and while enjoying the experience, they also love being admired — almost like having a '
        'devoted fan. Leo craves praise, so compliments in bed are definitely appreciated. As a lover, Leo’s passion is '
        'often focused on satisfying their partner’s needs. When being intimate with a Leo, foreplay and seduction are '
        'essential. One of their most sensitive areas is their back.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'You need to be the only star on the stage, while Virgo dislikes being in the spotlight and is happy to stay '
        'behind the scenes. When you passionately express your personal opinions, Virgo will quietly listen and offer '
        'practical, workable solutions for cooperation—without hurting your pride. Although they may think you’re a bit too '
        'self-satisfied, deep down they sometimes secretly admire your unshakable confidence.'
      ),
    },

    "Virgo": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'You two could truly be called a match made in heaven. Your values and outlooks are very similar — both of '
        'you seek a simple, stable life, dislike taking risks, and easily find emotional fulfillment. You get along '
        'extremely well, and the longer you’re together, the deeper your feelings grow — making it hard to part from one '
        'another. Your relationship is the kind that seeks steady growth within stability.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Virgo, an earth sign, is the slow-to-warm-up type. Anyone recognized as a true friend by them has definitely '
        'gone through the test of time and experience. Fellow earth signs who also prefer to take things slowly — such as '
        'Taurus and Capricorn — are especially compatible with Virgo. In addition, Scorpio is also an ideal best friend for '
        'Virgo, because both share sharp and unique insight, making them well suited to learn from and challenge each other.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Virgo’s performance in bed is nothing like their “name” might suggest — they definitely know what they’re '
        'doing. Their energy levels are usually high, and they bring both skill and sensual charm to intimacy. They enjoy '
        'the sensation of being touched and take pleasure in discovering the perfect spots for gentle caresses. Virgo isn’t '
        'typically driven by an especially high sexual appetite, but they do appreciate a thoughtfully planned and '
        'well-crafted intimate experience.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'Libra knows how to respect and appreciate your professional abilities. With their outgoing personality, '
        'they can complement your tendency to avoid frequent social interactions. In projects you’re jointly responsible '
        'for—whether it involves coordinating with other departments or communicating with supervisors to secure additional '
        'resources—Libra handles it with ease. Besides contributing to smooth execution, Libra’s harmonious attitude brings '
        'you a reassuring sense of trust.'
      ),
    },

    "Libra": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'Both of you are full of modern flair and intellectual charm. Being together feels pleasant and comfortable, '
        'without being overly clingy. In many situations, your thoughts align naturally — you share strong chemistry and '
        'understanding without even needing to say much. You also make a very outgoing pair: versatile, colorful, and full '
        'of variety — a truly eye-catching combination.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Libras are naturally skilled communicators. The friends who can chat with them about anything and everything '
        'are the ones who click with them most easily. Fellow air signs like Gemini and Aquarius — who are also articulate '
        'and full of fresh ideas — are especially well suited to Libra. Meanwhile, Aries, who complements Libra, can give '
        'the sometimes indecisive Libra a helpful push forward — making them both a good teacher and a supportive friend.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Libra is often regarded as the most refined sign of the zodiac. They possess a subtle sensitivity and a '
        'unique charm that can drive their partner wild. Libra knows how to stir desire through flirting, and they enjoy '
        'creating an unforgettable experience using sensual elements like lingerie, music, and chocolate — setting the '
        'stage for a breathtaking and perfectly orchestrated night of intimacy.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'When Aquarius encounters chaotic emergencies or complicated interpersonal situations, they can remain '
        'clear-headed and logically minded, just like you. At the same time, when faced with unfavorable circumstances, '
        'neither you nor Aquarius will display embarrassment or dramatic emotions. This ability to maintain a balance '
        'between emotional intelligence and getting things done not only allows you to support each other in achieving '
        'your goals during collaboration, but also creates a strong sense of mutual understanding between you.'
      ),
    },

    "Scorpio": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'When you first meet, you’ll immediately feel a sense of connection. The mutual understanding and appreciation '
        'between you will grow even stronger as your relationship deepens. If you meet after both having gone through life’s '
        'experiences, you’ll understand and commit to each other even more deeply — often knowing what the other is thinking '
        'without needing words. With such emotional and spiritual harmony, you can fully enjoy a mature and fulfilling love.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Scorpios are loyal and passionate toward their friends. With their sensitivity, they can sharply — sometimes '
        'even bluntly — point out a friend’s blind spots, helping them overcome difficult moments in life. Taurus, who also '
        'tends to think deeply like Scorpio, makes one of Scorpio’s best friends. The two are perfectly suited to sharing a '
        'late-night drink while talking about life’s big questions.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Scorpio is famous for having an intense libido and boundless passion. In bed, their desire is often sparked '
        'by themes of power, control, and role-play. By combining strong sexual drive with deep emotion, they can keep their '
        'partner completely captivated all night long. Thanks to their natural sexual magnetism, Scorpios rarely find '
        'themselves lacking admirers or partners.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'The common ground between you and Capricorn is your “ambition for your careers,” which makes both of you '
        'hold yourselves to high standards and focus most of your energy on achieving your goals. When facing difficulties, '
        'you can calmly assess the situation and know how to leverage available resources to overcome obstacles. Capricorn '
        'understands that your guardedness and shrewdness are simply ways of protecting yourself. As long as they don’t '
        'cross your boundaries, you are a trustworthy partner.'
      ),
    },

    "Sagittarius": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'You both share a common trait — a love of freedom and a dislike of being restricted. You’re also brave when '
        'it comes to trying new and trendy things. Because you think alike, you’re able to give each other space and time. '
        'Neither of you tries to control the other, which helps build a relationship founded on mutual trust. As the saying '
        'goes, “In a lover’s eyes, not even a grain of sand can be tolerated.” What truly matters is trust — and that’s why '
        'you two make such a perfect match.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Adventure-loving Sagittarius always has a great time with fellow fire signs like Aries and Leo — life is full '
        'of excitement and new experiences when they’re together. However, what many people don’t realize is that Sagittarius '
        'also has a more serious side. They care deeply about social justice, politics, and other important issues. Aquarius, '
        'who also has many ideas and strong opinions on such topics, would be an ideal companion for meaningful discussions with Sagittarius.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Sagittarius is charming, warm, and attentive in bed. They believe that partners who bring variety and freshness '
        'are the best match for them, because Sagittarians can easily become frustrated or bored with routine intimacy. Even in '
        'the bedroom, they enjoy adventurous experiences — trying new positions or even experimenting with toys to keep things exciting.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'Taurus can steadily handle the routine, administrative tasks you dislike dealing with, as well as matters '
        'related to budgets and finances. Even if they don’t agree with your imaginative, far-fetched ideas, they won’t '
        'criticize you to your face. When you and Taurus reach a consensus, it feels comfortable and at ease. Taurus also '
        'understands that you’re good at creating value and are willing to share the benefits. To them, this is a practical '
        'and reliable form of reciprocity.'
      ),
    },

    "Capricorn": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'Your partner is someone with ideals and dreams — considerate, gentle, and attentive — making it easy for '
        'others to develop a fondness for him/her. You, on the other hand, are practical, meticulous, and down-to-earth, '
        'and you are especially drawn to someone like your partner. Your partner also appreciates your deep affection and '
        'the strong sense of security you provide. Both of your personalities making you a highly compatible pair who can complement each other beautifully.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Capricorns aren’t especially fond of partying or indulgent fun. Compared to friends who only share food and '
        'entertainment, they value friends who can offer genuine support much more. Fellow earth signs like Virgo and Taurus '
        'are especially well suited to them. Cancer, who naturally provides care and emotional support, is also highly '
        'compatible with Capricorn. Their emotional richness can help make Capricorn’s life feel less dull and more warm.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Similar to Scorpio, Capricorn is known for being sexy, and it doesn’t take much time or effort to awaken a '
        'Capricorn’s sexual desire. They consider their legs and knees to be the most sensitive areas. Although they do '
        'not openly express their emotions, Capricorns do enjoy being pursued and seduced. In addition, they take pride '
        'in their “endurance” in bed.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'When you work, you’re like a machine—so serious and dedicated that you often exhaust yourself, which can '
        'lead to an inexplicable sense of emotional low spirits. Leo’s enthusiasm and cheerful nature, like the sun, can '
        'often warm your heart and help you feel the joy of creating results. Although Leo’s carefree attitude toward '
        'details may sometimes bring trouble to your working relationship—and they may even act spoiled and ask you to '
        'help out more—you’re still able to accept it and smooth things over.'
      ),
    },

    "Aquarius": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: 'You both share a common trait — a love of freedom and a dislike of being restricted. You’re also brave when '
        'it comes to trying new and trendy things. Because you think alike, you’re able to give each other space and time. '
        'Neither of you tries to control the other, which helps build a relationship founded on mutual trust. As the saying '
        'goes, “In a lover’s eyes, not even a grain of sand can be tolerated.” What truly matters is trust — and that’s why '
        'you two make such a perfect match.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Aquarius isn’t the clingy type of friend. They generally get along well with the people around them, but not '
        'necessarily in a deeply intimate or overly sentimental way. They’re often perfectly happy being on their own. '
        'However, adventurous signs like Sagittarius and Aries — who love trying new things — can pull Aquarius out of their '
        'comfort zone and help them experience a different kind of life, making them ideal best friends for Aquarius.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Aquarius is usually considered rational, but once the setting shifts to the bedroom, they become quite '
        'unconventional. They enjoy being seduced but dislike being controlled. On the surface, they appear to be '
        'passionate and imaginative lovers; in reality, they require strong intellectual stimulation from their partner.'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'You and Sagittarius both share a forward-looking, visionary perspective. Sagittarius loves being in the '
        'spotlight and showcasing their intelligence and talents, and you don’t feel that they are stealing your shine. '
        'When working toward a consensus together, neither of you lets emotions interfere with progress if things don’t go '
        'as expected. Instead, you both see it as another great opportunity to challenge tradition and explore new possibilities.'
      ),
    },

    "Pisces": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
         body: 'You are someone with ideals and dreams — considerate, gentle, and attentive — making it easy for '
        'others to feel drawn to you. Your partner, on the other hand, are practical, meticulous, and down-to-earth, '
        'and is especially attracted to someone like you. You also appreciates your partner’s deep affection and '
        'the strong sense of security he/she provides. Both of your personalities making you a highly compatible pair who can complement each other beautifully.'
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body: 'Pisces is highly sensitive and prone to emotional immersion, often feeling as though no one truly understands '
        'them. However, fellow water signs Scorpio and Cancer can become Pisces’s closest confidants. In addition, dependable '
        'Capricorn can give insecure Pisces a strong sense of security, while imaginative and dreamy Pisces can bring plenty of '
        'fun and inspiration into Capricorn’s life.'
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: 'Pisces are naturally sociable and easygoing. They’re not aggressive, yet they can effortlessly attract '
        'admirers. In the bedroom, Pisces are romantic, sensitive, and playful — can you win them over?'
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: 'When you and Scorpio work together, a strong mutual understanding naturally develops. Scorpio, who is '
        'highly self-protective and often suspicious of others, sees you as transparent and sincere, which gives them a '
        'sense of security. In the workplace, no matter what situation arises, Scorpio will be your solid support, '
        'helping to steady your uneasy emotions. Their calmness and emotional support also give you the courage to try '
        'new things and confidently make use of your strengths.'
      ),
    },
  };

  static ZodiacRelationshipDetail getDetail(
    String sign,
    String category, // "love" | "friendship" | "sex" | "work"
  ) {
    final signMap = _data[sign];
    final detail = signMap?[category] ?? _data["_default"]?[category];

    return detail ??
        const ZodiacRelationshipDetail(
          label: "Info",
          body: "No data available.",
        );
  }
}