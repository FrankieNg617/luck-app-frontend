class ZodiacStageData {
  final String label;
  final String body;

  const ZodiacStageData({
    required this.label,
    required this.body,
  });
}

class ZodiacStageRepository {
  static const Map<String, List<ZodiacStageData>> _stagesBySign = {
    'Aries': [
      ZodiacStageData(
        label: 'Mar 21 - Mar 31',
        body: 'At this stage, the ruling planet is Mars, and the personality tends to be very domineering. Aries traits are especially pronounced — often impatient, '
        'easily angered, highly aggressive, very independent, and occasionally a bit quirky. One area you can improve is avoiding overly authoritarian language. Being '
        'too forceful in how you speak can cause resentment in others. You have a very rich imagination and a strong trust in your own intuition — this is your special '
        'talent. However, when your intuition is wrong, you may be unwilling to admit it, and that’s something you should pay special attention to. When making decisions,'
        ' you often rely on your feelings and intuition. Therefore, it’s important to absorb more information regularly so your intuition can become more accurate. You are '
        'highly capable, but sometimes a lack of patience can prevent you from achieving success.'
      ),
      ZodiacStageData(
        label: 'Apr 1 - Apr 10',
        body: 'At this stage, the ruling planet is the Sun, which represents honor and brightness, as well as change and reform. Aries is naturally an active sign, '
        'and with the added influence of the Sun, this dynamism is strengthened — but without being overly domineering. You are actually someone who enjoys competition. '
        'You dislike routine or repetitive, boring work, so it’s important for you to constantly develop new ideas and abilities. The more you tap into your potential, '
        'the more you’ll be able to stand out. You also have a quick ability to gather information, somewhat similar to Gemini. Therefore, careers that are at the '
        'forefront of the times are especially well suited for Aries individuals born in this stage.'
      ),
      ZodiacStageData(
        label: 'Apr 11 - Apr 20',
        body: 'The ruling planet at this stage is Jupiter, which means people born in this phase are the most compassionate and morally conscious among Aries. You '
        'tend to be more polite and are not as headstrong or reckless as other Aries. Deep down, you are more delicate and sensitive, and you also possess stronger '
        'artistic talent. It’s important for you to reconcile the inner conflicts and contradictions within yourself, because you often act impulsively and later regret '
        'it deeply — feeling that you shouldn’t have behaved that way. You are a very kind person. Learning how to adjust and balance yourself — allowing your sensitive '
        'side to soften your impulsive nature — will help you become a successful individual.'
      ),
    ],

    'Taurus': [
      ZodiacStageData(
        label: 'Apr 21 - Apr 30',
        body: 'Taurus individuals in this stage are the most willing to help others among all Taureans. The personal ruling planet is Venus, which represents love '
        'and beauty. You are quite devoted in relationships and show compassion toward those around you. As a result, you are well suited for volunteer work or careers '
        'in service-related fields. For you, being able to use your artistic appreciation skills while also earning money would truly be the best of both worlds. You '
        'also need to communicate your inner feelings regularly. You are good at learning from others and absorbing their experiences — a distinctive trait of Taurus '
        'individuals born in this stage.'
      ),
      ZodiacStageData(
        label: 'May 1 - May 10',
        body: 'The personal ruling planet is Mercury, which represents knowledge. Therefore, Taurus individuals born in this stage are better at expressing themselves '
        'and can clearly articulate what they want and what they think. The only thing you need to overcome is being too thin-skinned. Sometimes, even when you know '
        'exactly what to say and how to express it, you hold back because you feel shy or fear failure. Make good use of your eloquence — it will greatly enhance your '
        'career, various aspects of your life, and your interpersonal relationships.',
      ),
      ZodiacStageData(
        label: 'May 11 - May 19',
        body: 'The personal ruling planet is Saturn, which makes you a steadier type of Taurus. You are the most patient, considerate, and thoughtful — but also the most '
        'conservative — among Taureans. Abundant energy is one of your defining traits. No matter what you do, you are able to work diligently and tirelessly. Others '
        'may think you don’t have much power, but you’re like a small train — steadily moving forward without stopping, running for a long time without complaining of '
        'fatigue. Endurance is your greatest weapon for success.'
      ),
    ],

    'Gemini': [
      ZodiacStageData(
        label: 'May 20 - May 31',
        body: 'Your personal ruling planet is Mercury, which gives you incredibly quick reactions. When someone is only halfway through speaking, you already understand '
        'their main point — and you can’t wait to draw a conclusion for them. You often feel that others are slow and inefficient, because you alone can accomplish the '
        'work of three people and already know exactly how things should be done. It’s recommended that you make good use of your strong communication skills to support '
        'your work. However, your emotionally sensitive side can easily influence your judgment, so be careful.'
      ),
      ZodiacStageData(
        label: 'Jun 1 - Jun 10',
        body: 'Your personal ruling planet is Venus. Although you often don’t mean what you say in a hurtful way, you may still unintentionally hurt others. You '
        'have a kind heart, but you’re used to analyzing things from a rational perspective. Because of this, people may sometimes see you as cold or unemotional. '
        'It’s recommended that you make more use of your sense of humor to offset this shortcoming — doing so will help you become a Gemini who is loved by everyone.'
      ),
      ZodiacStageData(
        label: 'Jun 11 - Jun 21',
        body: 'Your personal ruling planet is Saturn. When you’re in a bad mood, you can become like a puddle of mud — not wanting to do anything and even thinking about '
        'giving everything up. Therefore, you need to be careful about managing your emotions. Basically, you are an optimistic person. As long as you don’t let your '
        'emotions take control, your creativity can bring you substantial wealth.'
      ),
    ],

    'Cancer': [
      ZodiacStageData(
        label: 'Jun 22 - Jun 30',
        body: 'At this stage, the personal ruling planet is the Moon, which makes you especially sensitive — the most sensitive group among Cancers. Your ability to '
        'imitate and your artistic talents are both outstanding. However, modern society places great emphasis on efficiency, and your sensitive nature may be '
        'suppressed by the pressure of time and the demand for productivity. Therefore, Cancers born in this stage need to learn how to regulate their nervous system '
        'and understand the importance of relaxing and taking care of themselves.'
      ),
      ZodiacStageData(
        label: 'Jul 1 - Jul 11',
        body: 'The personal ruling planet is Mars, which usually represents fighting spirit and drive. Although your main ruling and guardian planet is the Moon, the '
        'added influence of Mars gives you greater decisiveness. You also tend to show strong impatience toward things that annoy you, and you may not be as tolerant as '
        'other Cancers. However, Cancers born during this stage are quite versatile and multi-talented. You also have good speaking skills, and you can use your '
        'eloquence to enhance your performance at work.'
      ),
      ZodiacStageData(
        label: 'Jul 12 - Jul 22',
        body: 'Your personal planets are Jupiter and Neptune, and their energies are in conflict. Jupiter represents good fortune, while Neptune symbolizes the '
        'spiritual realm. As a result, you often experience unexpected strokes of luck. Because you place great importance on the spiritual dimension of life, your '
        'partner must also value emotional and spiritual depth. When you buy things, they must not only be good quality at a reasonable price, but also possess artistic '
        'taste — you would never purchase something just because it’s cheap. Cancers born during this period seek both practicality and artistic value, which can give '
        'you a slight tendency to be a bit picky.'
      ),
    ],

    'Leo': [
      ZodiacStageData(
        label: 'Jul 23 - Jul 31',
        body: 'Leos born in this stage tend to have a gentler personality — not as forceful or domineering — though you still have an active, energetic streak. You '
        'possess considerable artistic talent and are highly perceptive when observing the world around you. You have a philosophical nature and are also quite skilled '
        'at psychological analysis. Most importantly, Leos born during this period often feel regret after making decisions. For you, being able to make excellent '
        'decisions in the moment requires first gathering sufficient information — that is both the most important and the most necessary step.'
      ),
      ZodiacStageData(
        label: 'Aug 1 - Aug 11',
        body: 'At this stage, you display very obvious Leo traits — you are extremely confident and self-assured, and your subjectivity is a bit stronger as well. '
        'Sometimes, you may unconsciously overpower others or come across as dominant. However, when it comes to friends, you are incredibly loyal and would go to great '
        'lengths for them. Your partner and friends are fortunate to have you — as long as they can occasionally tolerate your sudden bursts of temper. You tend to lack '
        'patience, so the people around you need to have a little extra patience in return.'
      ),
      ZodiacStageData(
        label: 'Aug 12 - Aug 22',
        body: 'Leos born in this stage carry a slight touch of Virgo-like traits. As a result, you have stronger abilities in analysis and self-reflection when handling '
        'matters. Afterward, you may even stay at home pondering the reasons for failure. However, you often feel overwhelmed halfway through thinking it over — finding '
        'it too troublesome or mentally exhausting — and then you simply stop analyzing it further. Therefore, seeing things through to the end and making full use of '
        'your analytical ability are the keys to success for Leos born in this stage. You also have a bit more empathy for others, allowing you to notice the feelings '
        'of people around you. This makes you a comparatively gentle and cautious Leo.'
      ),
    ],

    'Virgo': [
      ZodiacStageData(
        label: 'Aug 23 - Aug 31',
        body: 'Virgos born in this stage may handle things with a slight air of dominance and can be somewhat overly subjective — this is something you need to be '
        'mindful of. On the positive side, Virgos born during this period tend to be more decisive and less prone to hesitation. Combined with your natural analytical '
        'ability, this allows you to think things through clearly before taking action, and to let go more easily afterward. This is truly a very encouraging and '
        'admirable trait.'
      ),
      ZodiacStageData(
        label: 'Sep 1 - Sep 11',
        body: 'Virgos born during this period have Saturn as their personal ruling planet. You are extremely patient, considerate, and frugal. However, this doesn’t '
        'mean you are stingy. Rather, you believe that money should be spent where it truly matters. You don’t need others to supervise or guide you — you naturally '
        'move toward your goals on your own. No matter how complicated a situation may be, you are able to untangle it step by step and make it simple. What you need '
        'to strengthen is your ability to manage partnerships. While it’s important to get along well with your partners, you should also be careful not to let them '
        'become overly dependent on you.'
      ),
      ZodiacStageData(
        label: 'Sep 12 - Sep 22',
        body: 'Your personal ruling planet is Venus, which makes you more sensitive than other Virgos. You dislike damaging relationships between people, so sometimes '
        'you adopt the attitude of handling things yourself just to avoid harming a friendship. Over time, however, this can cause you to shoulder too much '
        'responsibility on your own. Because you are emotionally sensitive, you often feel hurt. But that’s okay — you can channel your sensitivity into developing '
        'other talents. For example, if you invest this sensitivity into writing or artistic creation, you will surely achieve excellent results. This way, you can '
        'avoid overthinking certain matters or getting stuck in a mental loop, while others may unintentionally hurt you without even realizing it — and that wouldn’t '
        'be worth it, would it?'
      ),
    ],

    'Libra': [
      ZodiacStageData(
        label: 'Sep 23 - Sep 30',
        body: 'Your personal ruling planet is Venus. At times, you can’t help but feel critical of certain people internally. However, on the surface, you still '
        'maintain harmonious and diplomatic relationships with them. A reminder for you: sometimes your desire to please everyone and handle everything perfectly can '
        'put you in a difficult dilemma. If things don’t end well, you may even blame yourself. The truth is, it’s impossible to satisfy everyone — and this is '
        'something you must clearly understand.'
      ),
      ZodiacStageData(
        label: 'Oct 1 - Oct 11',
        body: 'Your personal ruling planet is Saturn. You care deeply about your image, so even though you have many private feelings and emotions, you’re unwilling to '
        'reveal them easily in front of others. Even in front of someone you love, you may choose to stay silent — either because you don’t want them to worry about '
        'you, or because you’re too tired after a long day to explain. Instead, you prefer to let your emotions settle on their own. It’s recommended that you talk more '
        'with close, trusted friends — vent a little, complain a bit. Trust me, doing so will give you more motivation and vitality. No matter what you’re dealing with, '
        'try not to push yourself too hard.'
      ),
      ZodiacStageData(
        label: 'Oct 12 - Oct 22',
        body: 'Your personal ruling planet is Uranus. You often compromise yourself too much and neglect your own thoughts and needs. As a result, every so often you '
        'end up feeling deeply hurt — yet you still allow the same situation to continue. You need to learn how to say no. You must understand that in relationships, '
        'one-sided tolerance alone is not enough. It will only make the other person take you for granted.'
      ),
    ],

    'Scorpio': [
      ZodiacStageData(
        label: 'Oct 23 - Oct 31',
        body: 'Both your ruling planet and personal planet are Mars, which means you have double the drive and action power. Since Mars governs combativeness and '
        'initiative, the downside of this influence is that you can be very domineering and subjective. Put positively, you are highly independent and decisive in '
        'handling matters. Put less favorably, you can be somewhat headstrong and inclined to go your own way. At times, your strong subjectivity may make it hard for '
        'you to listen to others. In your career, you are likely to achieve significant success. In relationships, however, it would be better to adopt a softer '
        'attitude — try not to be overly strong-willed or rigid in personality.'
      ),
      ZodiacStageData(
        label: 'Nov 1 - Nov 11',
        body: 'During this period, the ruling planets are Jupiter and Neptune. Neptune usually governs deeper spirituality, while Jupiter governs happiness and good '
        'fortune. One represents the material realm, and the other represents the spiritual realm. As a result, your personality can be quite changeable, and you often '
        'have inner dialogues or conflicting thoughts within yourself. If you were a doctor, you would be especially suited to psychiatry. If you worked in the '
        'construction field, architectural design would suit you best. In other words, you excel at analysis and interpretation — this is a distinctive strength of '
        'yours in these areas.'
      ),
      ZodiacStageData(
        label: 'Nov 12 - Nov 21',
        body: 'Your personal ruling planet is the Moon, which represents imagination, dreams, and maternal love. Therefore, you are a softer and more gentle type of '
        'Scorpio. Scorpios naturally enjoy taking care of others, especially those they care deeply about. When it comes to your partner, your attentiveness is truly '
        'meticulous — making them feel warm and cherished. However, if you happen to be with the wrong partner, they might see your care as nagging instead.'
      ),
    ],

    'Sagittarius': [
      ZodiacStageData(
        label: 'Nov 22 - Nov 30',
        body: 'Both your ruling planet and personal planet are Jupiter, which makes you a Sagittarius with an especially strong sense of justice and compassion. You '
        'are very loyal and honest with your partner, and you carry the same integrity into your work — which often earns you recognition and appreciation from your '
        'boss. Your friends see you as someone trustworthy. You also have a strong curiosity about interpersonal relationships and genuinely care about your friends. '
        'These are all wonderful strengths that, when used well, can lead you to greater success in life. However, at times your ability to stay focused on one thing '
        'doesn’t last very long. This is an area that needs improvement.'
      ),
      ZodiacStageData(
        label: 'Dec 1 - Dec 11',
        body: 'At this stage, the personal ruling planet is Mars, so Sagittarians born during this period possess traits of initiative, adventure, and strong ambition. '
        'You enjoy change. At first, it brings you excitement and happiness, but later you may begin to feel a sense of emptiness. Even if you earn a great deal of '
        'money, you might still feel lonely inside. Therefore, nurturing and enriching your inner world is especially important. People born in this stage tend to have '
        'strong connections with foreign countries. Mastering foreign languages and broadening your international perspective are very important for you. However, you '
        'may lack administrative skills, so finding a capable assistant to support you will help take your career to the next level.'
      ),
      ZodiacStageData(
        label: 'Dec 12 - Dec 21',
        body: 'Your personal ruling planet is the Sun, so you place special importance on your dignity and self-respect — you’re also one of the most prideful '
        'Sagittarians. Usually, others can joke around with you, but if you’re truly irritated, you’ll quickly talk back. You enjoy debating, and no matter what, you '
        'believe you’re right. Even if others think your reasoning is flawed, you have your own internal logic to support it. You highly value freedom. Although you’re '
        'willing to endure and work hard for a career or a partner you love, the moment they interfere with your freedom or hinder your pursuits, you won’t be able to '
        'tolerate it. You are a responsible person, very patient, and serious about your work. You possess leadership ability and strong ambition — classic traits of a '
        'driven Sagittarius.'
      ),
    ],

    'Capricorn': [
      ZodiacStageData(
        label: 'Dec 22 - Dec 31',
        body: 'At this stage, the personal ruling planet is Saturn. Capricorns born during this period are the ones who find it the hardest to make friends. If you, '
        'as a Capricorn, have a friend, you should truly cherish them and regard them as a lifelong, loyal companion. For Capricorn, Saturn symbolizes endurance and '
        'permanence, as well as stability. Therefore, Capricorns born in this stage are even more stable and mature than those born in other stages. From childhood '
        'to adulthood, people may have thought you were a little unusual. However, you have always been very clear about your ambitions and what you want to achieve '
        'in the future. Capricorns born in this stage often have special talents in mechanics and mathematics. No matter what, you will always find a way to break a '
        'major goal down into medium-sized goals, and then further divide them into small daily tasks to accomplish step by step. You are one of the most persistent '
        'and determined Capricorns of all.'
      ),
      ZodiacStageData(
        label: 'Jan 1 - Jan 10',
        body: 'Your personal ruling planet is Venus, which makes you one of the warmer, more cheerful, and more charming Capricorns. Because of this, you’re not as '
        'purely practical or rigid as other Capricorns. Occasionally, you also appreciate art and enjoy music. Since Venus governs emotions and relationships, you '
        'are one of the most warm-hearted and affectionate Capricorns. Even when you feel like putting on a serious face and being very practical or calculating with '
        'friends, you ultimately end up being influenced by your feelings. You might see this as a weakness, but in fact, it adds a softer side to your personality — '
        'which is actually a wonderful strength.'
      ),
      ZodiacStageData(
        label: 'Jan 11 - Jan 19',
        body: 'Your personal ruling planet is Mercury, making you a more clear-minded Capricorn. Since Mercury governs the brain and the human nervous system, as well '
        'as communication and expression, you have the strongest expressive ability among all Capricorns. You’re also more adaptable and flexible, rather than rigid '
        'or stubborn. Unlike other Capricorns, you possess a strong sense of justice. Generally, Capricorns tend to focus primarily on their own matters, but you have '
        'an inexplicable sense of responsibility — somewhat similar to Sagittarius in this regard. Your most distinctive strength is your learning ability, as Mercury '
        'also governs foreign languages. If you’re interested in developing internationally, your aptitude for languages and your luck in overseas ventures will likely '
        'be better than most. Therefore, it would be wise to further develop your talents in this direction and invest more effort into it. Doing so will help you '
        'unlock even greater potential within your professional field.'
      ),
    ],

    'Aquarius': [
      ZodiacStageData(
        label: 'Jan 20 - Jan 31',
        body: 'At this stage, the ruling planet is Uranus, which represents a powerful spiritual force. Combined with your Aquarian traits, being born during this '
        'period gives you a particularly spiritual and ethereal temperament. Whether in religion or mysticism, you have exceptional insight and understanding. If you '
        'ever wanted to become a fortune teller — well, you’d actually be quite well suited for it! No matter what your ambitions are, people born in this stage will '
        'always accomplish them in a unique way. For example, while everyone else might rush to study in the UK or the US, you might feel drawn to places like Greece '
        'or Rome instead. If others choose to study law or politics, you’ll likely prefer something more unusual or unconventional. Make good use of your spiritual '
        'qualities — you are naturally gifted with the ability to see into the hearts of others.'
      ),
      ZodiacStageData(
        label: 'Feb 1 - Feb 9',
        body: 'At this stage, the ruling planet is Mercury, which primarily governs our nervous system. Because of this, your senses — such as touch and smell — tend '
        'to be more sensitive than those of the average person. You possess excellent observational skills and strong eloquence. Combined with your unique way of '
        'thinking, you probably leave many people quite astonished by the way you speak and reason. Any work related to knowledge is especially well suited to you. '
        'Not only do you absorb information quickly, but you can also “infer many things from a single example.” However, your patience may be somewhat lacking, so '
        'this is something you should pay extra attention to.'
      ),
      ZodiacStageData(
        label: 'Feb 10 - Feb 18',
        body: 'Your ruling planet is Venus. Your intuition and sixth sense are incredibly powerful — almost astonishing. However, if you don’t make good use of them, '
        'they can actually become obstacles instead. You often hold perspectives that differ from those of others. There’s nothing wrong with that. But if you '
        'completely refuse to listen to others’ opinions and assume they are shallow, you may end up experiencing setbacks because of it. The key to the phrase “Life '
        'is built on dreams” lies in turning dreams into reality through practical effort. Learning to balance dreams and reality is the most important lesson in your life.'
      ),
    ],

    'Pisces': [
      ZodiacStageData(
        label: 'Feb 19 - Feb 29',
        body: 'During this period, the ruling planet is Neptune, which governs the spiritual realm and artistic talent. As a result, your artistic ability is the '
        'most outstanding among all Pisces. However, your dual personality is also the most pronounced. Your thinking is very modern and innovative, yet sometimes '
        'you hesitate to voice your own opinions — this is an area you need to strengthen. When you combine your artistic talent with your unique way of thinking and '
        'apply it well in the workplace, you can certainly create a bright future for yourself. Therefore, the industry you choose should be one that welcomes new '
        'ideas and allows your talents to flourish. Companies that are too conservative or bosses who suppress you are not suitable for you.'
      ),
      ZodiacStageData(
        label: 'Mar 1 - Mar 10',
        body: 'Your ruling planet is the Moon, which governs the night and also represents love for family. Pisces born during this stage are the most family-oriented. '
        'At times, you may feel moody and enjoy indulging in fantasies, but when it comes to your family, you offer genuine and practical support. People born in this '
        'phase are especially sensitive to external influences and their surroundings. When you’re in a good mood, you feel that life is full of hope and you’re eager '
        'to help others. With your intense and rich emotional sensitivity, you can easily sense why someone else is feeling down. However, when your willpower is weak, '
        'you may even experience slight self-destructive or suicidal tendencies. Therefore, it’s important to channel this sensitive energy wisely. You may find your '
        'own path in fields such as religion or the service industry, where your compassion and sensitivity can truly shine.'
      ),
      ZodiacStageData(
        label: 'Mar 11 - Mar 20',
        body: 'Your personal ruling planet is Mars, which represents fighting spirit and action. This makes you the most action-oriented among all Pisces — '
        'congratulations! You prefer to act quickly and resolve matters efficiently, and you are quite proactive and sensitive. However, you may have a slight '
        'tendency to start strong but finish weak. You may not be ideally suited to being your own boss or building a business independently, because you tend to take '
        'all the responsibility upon yourself. In fact, working under someone else may suit you better. Pisces born during this period generally have strong artistic '
        'talent and high sensitivity. Still, I would suggest that you make greater use of your abundant energy and also strengthen your interpersonal relationships. '
        'Doing so will help your life progress more smoothly.'
      ),
    ],
  };

  static List<ZodiacStageData> getStages(String sign) {
    final s = sign.trim();
    final data = _stagesBySign[s];

    if (data != null && data.length == 3) {
      return data;
    }

    // Fallback (never crash)
    return const [
      ZodiacStageData(label: 'Stage 1', body: 'Coming soon.'),
      ZodiacStageData(label: 'Stage 2', body: 'Coming soon.'),
      ZodiacStageData(label: 'Stage 3', body: 'Coming soon.'),
    ];
  }
}