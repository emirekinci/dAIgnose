import 'package:grad_project/models/disease_info.dart';

final List<DiseaseInfo> diseaseList = [
  DiseaseInfo(
    id: "Egzama",
    names: {'en': "Eczema", 'tr': "Egzama"},
    descriptions: {
      'en':
          "Eczema is a chronic inflammatory skin condition causing redness, itching, and dryness. It may be triggered by allergens, irritants, or stress. Treatment includes topical corticosteroids, moisturizers, and avoiding triggers. At home, regular use of fragrance-free moisturizers, lukewarm baths, and avoiding scratching are helpful.",
      'tr':
          "Egzama, kızarıklık, kaşıntı ve kuruluğa neden olan kronik iltihaplı bir cilt hastalığıdır. Alerjenler, tahriş edici maddeler veya stres tarafından tetiklenebilir. Tedavisinde topikal kortikosteroidler, nemlendiriciler ve tetikleyicilerden kaçınma önerilir. Evde ise, parfümsüz nemlendiricilerin düzenli kullanımı, ılık banyolar ve kaşımaktan kaçınmak faydalı olabilir.",
    },
    imagePath: "assets/images/skin_disease/egzame.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Melanom",
    names: {'en': "Melanoma", 'tr': "Melanom"},
    descriptions: {
      'en':
          "Melanoma is a serious form of skin cancer that develops in pigment-producing cells. It often appears as an irregular, dark mole. Treatment involves surgical removal and, in advanced cases, immunotherapy or chemotherapy. No home treatment exists; early detection is vital.",
      'tr':
          "Melanom, pigment üreten hücrelerde gelişen ciddi bir cilt kanseri türüdür. Genellikle düzensiz şekilli, koyu renkli bir ben şeklinde ortaya çıkar. Tedavisi cerrahi olarak çıkarma yoluyla yapılır; ileri vakalarda ise immünoterapi veya kemoterapi uygulanabilir. Evde uygulanabilecek bir tedavisi yoktur; bu nedenle erken teşhis hayati öneme sahiptir.",
    },
    imagePath: "assets/images/skin_disease/melanom.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Atopik Dermatit",
    names: {'en': "Atopic Dermatitis", 'tr': "Atopik Dermatit"},
    descriptions: {
      'en':
          "A chronic skin disease that causes intense itching, inflammation, and dry patches, often in children. Treatment includes corticosteroid creams, antihistamines, and avoiding allergens. At home, moisturizing frequently and using mild soaps helps manage symptoms.",
      'tr':
          "Çocuklarda sık görülen, şiddetli kaşıntı, iltihaplanma ve kuru cilt bölgeleriyle seyreden kronik bir cilt hastalığıdır. Tedavisinde kortikosteroid kremler, antihistaminikler ve alerjenlerden kaçınma önerilir. Evde ise sık sık nemlendirme ve hafif (parfümsüz) sabunlar kullanmak, belirtilerin kontrol altına alınmasına yardımcı olur.",
    },
    imagePath: "assets/images/skin_disease/atopik_dermatit.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Bazal Hücreli Karsinom",
    names: {'en': "Basal Cell Carcinoma", 'tr': "Bazal Hücreli Karsinom"},
    descriptions: {
      'en':
          "This is the most common type of skin cancer, typically slow-growing and rarely spreads. Appears as a shiny bump or sore that doesn’t heal. Treatment involves surgical removal or topical treatments. No home remedy; medical intervention is required.",
      'tr':
          "Bu, en yaygın cilt kanseri türüdür; genellikle yavaş büyür ve nadiren yayılır. Parlak bir kabartı veya iyileşmeyen bir yara şeklinde görülebilir. Tedavisi cerrahi olarak çıkarma veya topikal tedavileri içerir. Evde uygulanabilecek bir tedavisi yoktur; tıbbi müdahale şarttır.",
    },
    imagePath: "assets/images/skin_disease/bazal_hucreli_karsinom.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Melanositik Nevus",
    names: {'en': "Melanocytic Nevi", 'tr': "Melanositik Nevus"},
    descriptions: {
      'en':
          "These are commonly known as moles and are usually harmless pigmented skin lesions. Regular monitoring is recommended for any changes. No treatment is needed unless cosmetic or cancer concerns arise. At home, sun protection is important to prevent changes.",
      'tr':
          "Bunlar halk arasında “ben” olarak bilinir ve genellikle zararsız, pigmentli cilt lezyonlarıdır. Herhangi bir değişiklik açısından düzenli olarak takip edilmeleri önerilir. Kozmetik nedenler veya kanser şüphesi olmadıkça tedavi gerekmez. Evde ise, güneşten korunmak, benlerde oluşabilecek değişiklikleri önlemek açısından önemlidir.",
    },
    imagePath: "assets/images/skin_disease/nevus.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "İyi Huylu Keratoz",
    names: {'en': "Benign Keratosis", 'tr': "İyi Huylu Keratoz"},
    descriptions: {
      'en':
          "These are non-cancerous skin growths that may look rough, scaly, or wart-like. Treatment is not necessary unless bothersome. Dermatological removal techniques like cryotherapy can be used. At home, gentle exfoliation and moisturizing may help reduce irritation.",
      'tr':
          "Bunlar, kanserli olmayan (iyi huylu) cilt büyümeleridir ve genellikle pürüzlü, kabuklu ya da siğile benzer bir görünümde olabilirler. Rahatsızlık vermedikçe tedavi gerektirmezler. Gerekli durumlarda, kriyoterapi (dondurarak alma) gibi dermatolojik yöntemlerle çıkarılabilir. Evde ise, nazik peeling (ölü deri temizleme) ve düzenli nemlendirme, tahrişi azaltmaya yardımcı olabilir.",
    },
    imagePath: "assets/images/skin_disease/iyi_huylu_keratoz.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Sedef Hastalığı",
    names: {'en': "Psoriasis", 'tr': "Sedef Hastalığı"},
    descriptions: {
      'en':
          "Chronic autoimmune skin conditions causing thick, scaly patches or purple lesions. Treatment includes corticosteroids, light therapy, and immune-modulating drugs. At home, regular moisturizing, avoiding skin trauma, and managing stress can reduce flare-ups.",
      'tr':
          "Kronik otoimmün cilt hastalıklarıdır; kalın, pul pul döküntüler veya mor renkli lezyonlara neden olurlar. Tedavide kortikosteroidler, ışık terapisi ve bağışıklık sistemini düzenleyen ilaçlar kullanılır. Evde ise, düzenli nemlendirme, cilt travmasından kaçınma ve stresi yönetme alevlenmeleri azaltmaya yardımcı olabilir.",
    },
    imagePath: "assets/images/skin_disease/sedef.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Seboreik Keratoz",
    names: {'en': "Seborrheic Keratoses", 'tr': "Seboreik Keratoz"},
    descriptions: {
      'en':
          "These are common non-cancerous skin growths appearing as waxy or rough spots. They often increase with age. No treatment is needed unless for cosmetic reasons. At home, no effective treatment exists, but irritation can be minimized by avoiding friction.",
      'tr':
          "Bunlar, mumumsu ya da pürüzlü görünüme sahip, yaygın iyi huylu cilt büyümeleridir. Genellikle yaşla birlikte sayıları artar. Kozmetik nedenler olmadıkça tedavi gerektirmezler. Evde etkili bir tedavi yoktur, ancak sürtünmeden kaçınarak tahriş azaltılabilir.",
    },
    imagePath: "assets/images/skin_disease/seboreik_keratoz.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Tinea / Mantar Enfeksiyonu - Kandidiyazis",
    names: {
      'en': "Tinea / Ringworm - Candidiasis",
      'tr': "Tinea / Mantar Enfeksiyonu - Kandidiyazis",
    },
    descriptions: {
      'en':
          "These are fungal infections that affect the skin, nails, or mucous membranes, often causing itching, redness, and scaling. Treatment includes antifungal creams or oral medications. At home, keeping the area dry, using antifungal powders, and avoiding tight clothing help prevent spread.",
      'tr':
          "Bunlar, deri, tırnak veya mukozaları etkileyen mantar enfeksiyonlarıdır; genellikle kaşıntı, kızarıklık ve pul pul dökülme yaparlar. Tedavi, antifungal kremler veya oral ilaçlar ile yapılır. Evde ise, etkilenmiş bölgenin kuru tutulması, antifungal tozların kullanılması ve sıkı kıyafetlerden kaçınılması, enfeksiyonun yayılmasını önlemeye yardımcı olur.",
    },
    imagePath: "assets/images/skin_disease/mantar_kandi.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Siğil - Molluskum Kontagiozum",
    names: {'en': "Warts Molluscum", 'tr': "Siğil - Molluskum Kontagiozum"},
    descriptions: {
      'en':
          "These are skin conditions caused by viruses such as human papillomavirus (HPV) for warts and molluscum contagiosum virus for molluscum. Warts appear as rough, raised growths, often on hands or feet, while molluscum appears as small, dome-shaped bumps. Treatment includes cryotherapy, salicylic acid, or minor surgical removal. At home, salicylic acid products, duct tape occlusion (for warts), and keeping the lesions clean and covered can help. However, they often resolve on their own in months.",
      'tr':
          "Bunlar, siğiller için insan papilloma virüsü (HPV) ve molluskum için molluscum kontagiozum virüsü gibi virüslerin neden olduğu cilt hastalıklarıdır. Siğiller genellikle eller veya ayaklarda görülen, pürüzlü, kabarık büyümeler şeklindedir; molluskum ise küçük, kubbe biçimli kabarcıklar olarak ortaya çıkar. Tedavide kriyoterapi, salisilik asit veya küçük cerrahi müdahaleler kullanılır. Evde ise, salisilik asit içeren ürünler, siğiller için bant kapama yöntemi (duct tape occlusion) ve lezyonların temiz ve kapalı tutulması faydalı olabilir. Ancak çoğu zaman, bu lezyonlar birkaç ay içinde kendi kendine iyileşir.",
    },
    imagePath: "assets/images/skin_disease/sigil.png",
    category: DiseaseCategory.skin,
  ),
  DiseaseInfo(
    id: "Diş Taşı",
    names: {'en': "Calculus", 'tr': "Diş Taşı"},
    descriptions: {
      'en':
          "Calculus is hardened dental plaque that builds up on the teeth, usually near the gumline. It can cause gum disease and bad breath. Treatment requires professional cleaning (scaling) by a dentist. At home, brushing twice a day, flossing, and using an antiseptic mouthwash help prevent its formation.",
      'tr':
          "Diş taşı, genellikle diş eti çizgisi yakınında dişlerde biriken sertleşmiş diş plağıdır. Diş eti hastalığına ve kötü nefese neden olabilir. Tedavisi, diş hekimi tarafından yapılan profesyonel temizlik (diş taşı temizliği) gerektirir. Evde ise, günde iki kez diş fırçalamak, diş ipi kullanmak ve antiseptik bir ağız gargarası ile ağız bakımını desteklemek oluşumunu önlemeye yardımcı olur.",
    },
    imagePath: "assets/images/oral_disease/dis_tasi.png",
    category: DiseaseCategory.oral,
  ),
  DiseaseInfo(
    id: "Diş Çürüğü",
    names: {'en': "Dental Caries", 'tr': "Diş Çürüğü"},
    descriptions: {
      'en':
          "Dental caries is the decay of teeth caused by acid-producing bacteria that erode the enamel. It begins as a small cavity and can lead to pain or infection. Treatment involves removing the decay and placing a filling or crown. At home, regular brushing with fluoride toothpaste, flossing, and limiting sugar intake are essential.",
      'tr':
          "Diş çürüğü, mineyi aşındıran asit üreten bakterilerin neden olduğu diş çürümesidir. Küçük bir boşluk (kavite) olarak başlar ve ağrıya veya enfeksiyona yol açabilir. Tedavi, çürüğün temizlenip dolgu veya kaplama yapılmasını içerir. Evde ise düzenli olarak florürlü diş macunu ile diş fırçalamak, diş ipi kullanmak ve şeker tüketimini sınırlamak oldukça önemlidir.",
    },
    imagePath: "assets/images/oral_disease/dis_curugu.png",
    category: DiseaseCategory.oral,
  ),
  DiseaseInfo(
    id: "Diş Eti İltihabı",
    names: {'en': "Gingivitis", 'tr': "Diş Eti İltihabı"},
    descriptions: {
      'en':
          "Gingivitis is the inflammation of the gums caused by plaque buildup. Symptoms include redness, swelling, and bleeding gums. Professional treatment involves scaling and improved oral hygiene. At home, brushing, flossing, and using an antibacterial mouthwash can reverse early-stage gingivitis.",
      'tr':
          "Diş eti iltihabı, plak birikiminin neden olduğu diş eti iltihabıdır. Belirtileri arasında kızarıklık, şişlik ve diş eti kanaması yer alır. Profesyonel tedavi, diş taşı temizliği (scaling) ve ağız hijyeninin iyileştirilmesini içerir. Evde ise diş fırçalama, diş ipi kullanma ve antibakteriyel ağız gargarası kullanımı, gingivitisin erken evresini tersine çevirebilir.",
    },
    imagePath: "assets/images/oral_disease/dis_eti_iltihabi.png",
    category: DiseaseCategory.oral,
  ),
  DiseaseInfo(
    id: "Aft / Ağız Yarası",
    names: {'en': "Mouth Ulcer", 'tr': "Aft / Ağız Yarası"},
    descriptions: {
      'en':
          "Mouth ulcers are small, painful sores inside the mouth, often caused by stress, injury, or nutritional deficiencies. They usually heal within 1–2 weeks. At home, saltwater rinses, avoiding spicy foods, and using topical numbing gels or protective pastes can relieve discomfort.",
      'tr':
          "Aftlar (ağız yaraları), ağız içinde oluşan küçük, ağrılı yaralardır ve genellikle stres, yaralanma veya beslenme eksikliklerinden kaynaklanır. Genellikle 1–2 hafta içinde kendiliğinden iyileşirler. Evde, tuzlu su ile gargara yapmak, baharatlı yiyeceklerden kaçınmak ve lokal uyuşturucu jeller veya koruyucu macunlar kullanmak rahatsızlığı hafifletebilir.",
    },
    imagePath: "assets/images/oral_disease/aft.png",
    category: DiseaseCategory.oral,
  ),
  DiseaseInfo(
    id: "Hipodonti",
    names: {'en': "Hypodontia", 'tr': "Hipodonti"},
    descriptions: {
      'en':
          "Hypodontia is the congenital absence of one or more teeth. It can affect both function and appearance. Treatment options include orthodontic appliances, bridges, or dental implants depending on severity. There is no home remedy; diagnosis and planning must be done by a dental specialist.",
      'tr':
          "Hipodonti, bir veya daha fazla dişin doğuştan eksik olması durumudur. Hem işlevi hem de estetiği etkileyebilir. Tedavi seçenekleri, eksikliğin ciddiyetine bağlı olarak ortodontik apareyler, köprüler veya dental implantları içerebilir. Evde uygulanabilecek bir tedavisi yoktur; tanı ve tedavi planlaması mutlaka bir diş hekimi tarafından yapılmalıdır.",
    },
    imagePath: "assets/images/oral_disease/hipodonti.png",
    category: DiseaseCategory.oral,
  ),
  DiseaseInfo(
    id: "Diş Renklenmesi",
    names: {'en': "Tooth Discoloration", 'tr': "Diş Renklenmesi"},
    descriptions: {
      'en':
          "Tooth discoloration is the change in color or shade of teeth, caused by staining foods, smoking, aging, or certain medications. It can be extrinsic (surface stains) or intrinsic (within the tooth). Treatment options include professional cleaning, whitening procedures, or veneers. Good oral hygiene and avoiding stain-causing substances help prevent discoloration.",
      'tr':
          "Diş renklenmesi, dişlerin renginde veya tonunda meydana gelen değişikliktir ve lekeli yiyecekler, sigara, yaşlanma veya bazı ilaçlar nedeniyle oluşabilir. Renklenme, dış (yüzey lekeleri) ya da iç (dişin yapısı içinde) olabilir. Tedavi seçenekleri arasında profesyonel temizlik, beyazlatma işlemleri veya porselen laminalar (veneers) bulunur. İyi bir ağız hijyeni sağlamak ve leke oluşturan maddelerden kaçınmak, renklenmeyi önlemeye yardımcı olur.",
    },
    imagePath: "assets/images/oral_disease/dis_renklenmesi.png",
    category: DiseaseCategory.oral,
  ),
  DiseaseInfo(
    id: "Akral Lentiginöz Melanom",
    names: {
      'en': "Acral Lentiginous Melanoma",
      'tr': "Akral Lentiginöz Melanom",
    },
    descriptions: {
      'en':
          "This is a rare and aggressive type of skin cancer typically seen on the soles of the feet, palms of the hands, or under the nails especially the thumb or big toe. It often begins as a dark line or spot under the nail. Treatment requires surgical intervention and, in some cases, additional therapies like chemotherapy or immunotherapy. There is no home treatment for this condition; however, recognizing unusual nail changes early and consulting a doctor is critically important.",
      'tr':
          "Bu, genellikle ayak tabanlarında, avuç içlerinde veya özellikle başparmak ya da ayak başparmağı tırnaklarının altında görülen nadir ve agresif bir cilt kanseri türüdür. Genellikle tırnağın altında koyu bir çizgi veya leke olarak başlar. Tedavi cerrahi müdahale gerektirir ve bazı durumlarda kemoterapi veya immünoterapi gibi ek tedaviler de uygulanabilir. Bu durum için evde uygulanabilecek bir tedavi yoktur; ancak, tırnaklardaki alışılmadık değişikliklerin erken fark edilmesi ve bir doktora danışılması hayati derecede önemlidir.",
    },
    imagePath: "assets/images/nail_disease/akral_melanom.png",
    category: DiseaseCategory.nail,
  ),
  DiseaseInfo(
    id: "Mavi Parmak",
    names: {'en': "Blue Finger", 'tr': "Mavi Parmak"},
    descriptions: {
      'en':
          "This refers to bluish discoloration in the fingers due to poor circulation, often caused by Raynaud’s disease, vascular blockage, or exposure to cold. Home treatment includes placing the affected area in warm water, wearing gloves in cold weather, avoiding smoking, managing stress, and reducing caffeine intake. Regular exercise can help improve circulation. Persistent or recurring cases should be evaluated by a physician.",
      'tr':
          "Bu, genellikle Raynaud hastalığı, damar tıkanıklığı veya soğuğa maruz kalma nedeniyle dolaşım bozukluğuna bağlı olarak parmaklarda meydana gelen mavimsi renk değişikliğini ifade eder. Evde uygulanabilecek tedaviler arasında etkilenen bölgenin ılık suya konulması, soğuk havalarda eldiven giyilmesi, sigaradan uzak durulması, stresin yönetilmesi ve kafein alımının azaltılması yer alır. Düzenli egzersiz, dolaşımın iyileştirilmesine yardımcı olabilir. Sürekli tekrarlayan veya geçmeyen durumların bir doktor tarafından değerlendirilmesi gerekir.",
    },
    imagePath: "assets/images/nail_disease/mavi_parmak.png",
    category: DiseaseCategory.nail,
  ),
  DiseaseInfo(
    id: "Çomak Parmak",
    names: {'en': "Clubbing", 'tr': "Çomak Parmak"},
    descriptions: {
      'en':
          "This condition involves the widening of the fingertips and the downward curving of the nails, often associated with chronic illnesses like lung disease, heart conditions, or gastrointestinal disorders. There is no direct home treatment, but quitting smoking, eating healthily, exercising regularly, and adhering to prescribed treatments for underlying illnesses can be beneficial. The deformity itself is usually irreversible, but progression can sometimes be slowed.",
      'tr':
          "Bu durum, genellikle ayak başparmağındaki tırnağın kalınlaşmasına, sararmasına ve kıvrık ya da bükülmüş bir şekilde uzamasına neden olur. Yaşlanma, dolaşım sorunları veya tekrarlayan travmalarla ilişkili olabilir. Evde bakım, ayakların ılık sabunlu suda bekletilmesini, tırnak yumuşadıktan sonra dikkatlice kesilmesini ve kalınlığının törpüyle azaltılmasını içerir. Ayakların temiz ve kuru tutulması da önemlidir. Ancak tırnak ciddi şekilde şekil bozukluğu gösteriyorsa, profesyonel tıbbi tedavi gereklidir.",
    },
    imagePath: "assets/images/nail_disease/comak_parmak.png",
    category: DiseaseCategory.nail,
  ),
  DiseaseInfo(
    id: "Sağlıklı Parmak",
    names: {'en': "Healthy Nail", 'tr': "Sağlıklı Parmak"},
    descriptions: {
      'en':
          "A healthy nail appears pink, smooth, non-brittle, and naturally shaped. No treatment is necessary. To maintain nail health at home, regular nail care, a balanced diet rich in vitamins, and avoiding overexposure to water or harsh chemicals are recommended. Biotin (vitamin B7) supplements can help strengthen nails.",
      'tr':
          "Sağlıklı bir tırnak pembe renkli, düzgün, kırılgan olmayan ve doğal şekilli görünür. Herhangi bir tedaviye gerek yoktur. Tırnak sağlığını korumak için evde düzenli tırnak bakımı, vitamin açısından zengin dengeli bir beslenme ve suya ya da sert kimyasallara aşırı maruz kalmaktan kaçınılması önerilir. Biyotin (B7 vitamini) takviyeleri tırnakların güçlenmesine yardımcı olabilir.",
    },
    imagePath: "assets/images/nail_disease/saglikli_parmak.png",
    category: DiseaseCategory.nail,
  ),
  DiseaseInfo(
    id: "Onikogrifozis",
    names: {'en': "Onychogryphosis", 'tr': "Onikogrifozis"},
    descriptions: {
      'en':
          "This condition causes the nail, usually on the big toe, to thicken, turn yellow, and grow in a curved or twisted shape. It may be associated with aging, circulation problems, or repeated trauma. Home care includes soaking the feet in warm soapy water, carefully trimming the nail after it softens, and using a nail file to reduce its thickness. Maintaining clean and dry feet is also important. However, if the nail becomes severely deformed, professional medical treatment is necessary.",
      'tr':
          "Bu durum, parmak uçlarının genişlemesi ve tırnakların aşağıya doğru kıvrılmasıyla karakterizedir; genellikle akciğer hastalıkları, kalp rahatsızlıkları veya gastrointestinal (sindirim sistemi) bozukluklar gibi kronik hastalıklarla ilişkilidir. Doğrudan bir ev tedavisi yoktur, ancak sigarayı bırakmak, sağlıklı beslenmek, düzenli egzersiz yapmak ve altta yatan hastalıklar için reçete edilen tedavilere uymak faydalı olabilir. Tırnaklardaki şekil bozukluğu genellikle geri döndürülemez, ancak ilerlemesi bazen yavaşlatılabilir.",
    },
    imagePath: "assets/images/nail_disease/onikogrifozis.png",
    category: DiseaseCategory.nail,
  ),
  DiseaseInfo(
    id: "Tırnak Çukurları",
    names: {'en': "Pitting", 'tr': "Tırnak Çukurları"},
    descriptions: {
      'en':
          "This condition presents as tiny, pinpoint depressions in the nail surface and is often linked with autoimmune diseases such as psoriasis or alopecia areata. At home, moisturizing the nails (for example, with vitamin E creams), avoiding aggressive trimming or filing, and using protective gloves can help. Anti-inflammatory supplements like omega-3 fatty acids may offer some benefit. Nonetheless, proper diagnosis and treatment of the underlying condition under a dermatologist's care are necessary for lasting improvement.",
      'tr':
          "Bu durum, tırnak yüzeyinde küçük, iğne ucu gibi çöküntüler şeklinde görülür ve genellikle sedef hastalığı (psoriasis) veya saçkıran (alopecia areata) gibi otoimmün hastalıklarla ilişkilidir. Evde bakım olarak tırnakların nemlendirilmesi (örneğin E vitamini içeren kremlerle), agresif kesim veya törpülemeden kaçınılması ve koruyucu eldiven kullanılması önerilir. Omega-3 gibi anti-inflamatuar takviyeler de bir miktar fayda sağlayabilir. Ancak, kalıcı iyileşme için altta yatan hastalığın doğru şekilde teşhis edilip bir dermatolog gözetiminde tedavi edilmesi gereklidir.",
    },
    imagePath: "assets/images/nail_disease/tirnak_cukurlari.png",
    category: DiseaseCategory.nail,
  ),
];
