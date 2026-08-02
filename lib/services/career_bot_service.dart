import 'dart:math';

class CareerBotResult {
  final String text;
  final String category;
  final List<String> followUps;

  CareerBotResult({
    required this.text,
    required this.category,
    required this.followUps,
  });
}

class CareerBotService {
  static CareerBotResult getResponse(String userMessage, String localeCode) {
    final text = userMessage.toLowerCase().trim();
    final isVi = localeCode == 'vi';

    if (text.contains('stem') || text.contains('công nghệ') || text.contains('it') || text.contains('tech') || text.contains('lập trình')) {
      return CareerBotResult(
        category: 'STEM',
        text: isVi
            ? "🔬 Khối ngành STEM & Công nghệ (IT, AI, Data Science):\n\n"
              "📊 Mức độ Phù hợp ước tính: 90% - 95% (Rất Phù Hợp với người thích tư duy logic, máy tính)\n"
              "📚 Khối thi THPT Đề xuất: A00 (Toán-Lý-Hóa), A01 (Toán-Lý-Anh), D07 (Toán-Hóa-Anh).\n"
              "🏫 Top Trường Đại học tại Việt Nam: ĐH Bách Khoa (Hà Nội/TP.HCM), ĐH Khoa học Tự nhiên (VNU), ĐH CNTT (UIT), ĐH Cần Thơ, Học viện Bưu chính Viễn thông.\n"
              "💡 Cơ hội việc làm: Kỹ sư phần mềm, Chuyên gia AI, Phân tích dữ liệu, An ninh mạng.\n\n"
              "🚀 Lời khuyên THPT: Tập trung nâng cao Toán, Tiếng Anh và làm quen tư duy lập trình từ sớm!"
            : "🔬 STEM & Technology Field (IT, AI, Data Science):\n\n"
              "📊 Estimated Match Rating: 90% - 95% (Highly Recommended for logical thinkers)\n"
              "📚 Subject Combos: A00 (Math-Phys-Chem), A01 (Math-Phys-Eng), D07 (Math-Chem-Eng).\n"
              "🏫 Top Universities in Vietnam: Hanoi Univ of Science & Tech (HUST), VNU-HCMUT, UIT, VNU-NUS.\n"
              "💡 Careers: Software Engineer, AI Specialist, Data Analyst, Cybersecurity Expert.\n\n"
              "🚀 High School Tip: Focus on Math and English fluency early on!",
        followUps: isVi
            ? [
                "Top trường đào tạo CNTT hàng đầu Việt Nam?",
                "Mức lương khởi điểm ngành AI & Data Science?",
                "Lớp 11 nên bắt đầu học lập trình thế nào?"
              ]
            : [
                "Top Computer Science Universities?",
                "Starting salary for AI engineers?",
                "How to start coding in Grade 11?"
              ],
      );
    }

    if (text.contains('holland') || text.contains('riasec') || text.contains('trắc nghiệm') || text.contains('test')) {
      return CareerBotResult(
        category: 'Holland',
        text: isVi
            ? "🧩 Trắc nghiệm Tính cách Hướng nghiệp Holland (RIASEC):\n\n"
              "📊 Mức độ Phù hợp với Chọn ngành: 95% (Công cụ chuẩn mực quốc tế)\n"
              "1. R - Realistic (Thực tế): Thích thao tác kỹ thuật -> Hợp Khối A00, A01 (Bách Khoa, GTVT).\n"
              "2. I - Investigative (Nghiên cứu): Thích phân tích -> Hợp Khối A00, B00 (Khoa học Tự nhiên, Y Dược).\n"
              "3. A - Artistic (Nghệ thuật): Thích sáng tạo -> Hợp Khối H00, V00, D01 (Mỹ thuật, Kiến trúc).\n"
              "4. S - Social (Xã hội): Thích giúp đỡ -> Hợp Khối C00, D01 (Sư phạm, Nhân văn, Tâm lý).\n"
              "5. E - Enterprising (Quản lý): Thích lãnh đạo -> Hợp Khối A01, D01 (Kinh tế Quốc dân, FTU).\n"
              "6. C - Conventional (Nghiệp vụ): Thích quy chuẩn -> Hợp Khối A00, D01 (Tài chính, Kế toán).\n\n"
              "❓ Bạn cảm thấy nhóm tính cách nào miêu tả đúng nhất bản thân?"
            : "🧩 Holland RIASEC Career Personality Assessment:\n\n"
              "📊 Usefulness Match Rating: 95% (Global gold standard for high schoolers)\n"
              "1. R - Realistic: Practical, engineering -> Combos A00, A01.\n"
              "2. I - Investigative: Analytical, science -> Combos A00, B00.\n"
              "3. A - Artistic: Creative, design -> Combos H00, V00, D01.\n"
              "4. S - Social: Counseling, teaching -> Combos C00, D01.\n"
              "5. E - Enterprising: Leadership, business -> Combos A01, D01.\n"
              "6. C - Conventional: Structured, accounting -> Combos A00, D01.\n\n"
              "❓ Which RIASEC group describes you best?",
        followUps: isVi
            ? [
                "Tôi thuộc nhóm R & I thì hợp ngành gì?",
                "Làm bài test Holland ở đâu miễn phí?",
                "Nếu tôi thuộc nhóm Nghệ thuật (A) thì sao?"
              ]
            : [
                "Majors for Realistic (R) & Investigative (I)?",
                "Where to take official RIASEC test?",
                "Careers for Artistic (A) personality?"
              ],
      );
    }

    if (text.contains('khối') || text.contains('môn') || text.contains('subject') || text.contains('a00') || text.contains('d01') || text.contains('b00') || text.contains('c00')) {
      return CareerBotResult(
        category: 'Subjects',
        text: isVi
            ? "📚 Phân tích Khối thi THPT Quốc gia & Mức độ Phù hợp Ngành:\n\n"
              "🔹 A00 (Toán, Lý, Hóa): Phù hợp (92%) cho CNTT, Kỹ thuật Bách khoa, Điện tử, Xây dựng.\n"
              "🔹 A01 (Toán, Lý, Anh): Phù hợp (95%) cho Tự động hóa, Quản trị kinh doanh, Tài chính, Logistics.\n"
              "🔹 B00 (Toán, Hóa, Sinh): Phù hợp (90%) cho Y đa khoa, Dược học, Công nghệ Sinh học tại ĐH Y Hà Nội / ĐH Y Dược TP.HCM.\n"
              "🔹 C00 (Văn, Sử, Địa): Phù hợp (88%) cho Luật, Sư phạm, Báo chí & Truyền thông tại ĐH Khoa học Xã hội & Nhân văn.\n"
              "🔹 D01 (Toán, Văn, Anh): Phù hợp (95%) cho Ngôn ngữ, Kinh tế Đối ngoại, Marketing tại ĐH Ngoại thương, NEU.\n\n"
              "❓ Bạn đang học tập trung vào khối thi nào ở trường THPT?"
            : "📚 High School Subject Combinations & University Match Analysis:\n\n"
              "🔹 A00 (Math, Phys, Chem): High Match (92%) for IT, Engineering, Robotics.\n"
              "🔹 A01 (Math, Phys, Eng): High Match (95%) for Automation, Business Admin, Finance.\n"
              "🔹 B00 (Math, Chem, Bio): High Match (90%) for Medicine, Pharmacy, Biotechnology.\n"
              "🔹 C00 (Lit, Hist, Geo): High Match (88%) for Law, Journalism, Social Sciences.\n"
              "🔹 D01 (Math, Lit, Eng): High Match (95%) for Foreign Languages, International Trade, Marketing.\n\n"
              "❓ Which subject track is your top strength in high school?",
        followUps: isVi
            ? [
                "Điểm chuẩn khối D01 năm nay thế nào?",
                "Học khối A01 có dễ xin việc không?",
                "Khối B00 ngoài ngành Y còn ngành nào hot?"
              ]
            : [
                "Cut-off scores for D01 subjects?",
                "Is A01 combo versatile for jobs?",
                "Alternative majors for B00 science track?"
              ],
      );
    }

    if (text.contains('kinh tế') || text.contains('business') || text.contains('marketing') || text.contains('tài chính')) {
      return CareerBotResult(
        category: 'Business',
        text: isVi
            ? "💼 Khối ngành Kinh tế, Quản trị & Marketing:\n\n"
              "📊 Mức độ Phù hợp ước tính: 88% - 94% (Rất Phù Hợp với người linh hoạt, năng động)\n"
              "📚 Khối thi Đề xuất: A00, A01, D01, D07.\n"
              "🏫 Top Trường Đại học tại Việt Nam: ĐH Kinh tế Quốc dân (NEU), ĐH Ngoại thương (FTU), ĐH Kinh tế TP.HCM (UEH), Học viện Tài chính.\n"
              "💡 Ngành Hot: Digital Marketing, Tài chính - Ngân hàng, Quản trị Kinh doanh, Thương mại Quốc tế.\n\n"
              "🚀 Lời khuyên THPT: Rèn luyện Tiếng Anh (IELTS/TOEIC) và kỹ năng làm việc nhóm từ sớm!"
            : "💼 Business, Finance & Marketing Field:\n\n"
              "📊 Estimated Match Rating: 88% - 94% (Highly Recommended for active, communicative minds)\n"
              "📚 Subject Combos: A00, A01, D01, D07.\n"
              "🏫 Top Universities in Vietnam: Foreign Trade Univ (FTU), National Economics Univ (NEU), UEH.\n"
              "💡 Top Majors: Digital Marketing, Finance, International Business, Supply Chain Management.\n\n"
              "🚀 High School Tip: Boost your English score and team presentation skills early!",
        followUps: isVi
            ? [
                "Khác biệt giữa Marketing và Quản trị kinh doanh?",
                "Ngành Logistics cần học những môn gì?",
                "Cần chuẩn bị gì khi thi vào khối Kinh tế?"
              ]
            : [
                "Difference between Marketing and Business Admin?",
                "What skills are needed for Logistics?",
                "How to prepare for Business majors in high school?"
              ],
      );
    }

    if (text.contains('thiết kế') || text.contains('arts') || text.contains('truyền thông') || text.contains('design')) {
      return CareerBotResult(
        category: 'Arts',
        text: isVi
            ? "🎨 Khối ngành Thiết kế, Nghệ thuật & Truyền thông:\n\n"
              "📊 Mức độ Phù hợp ước tính: 85% - 92% (Phù hợp với học sinh sáng tạo, gu thẩm mỹ cao)\n"
              "📚 Khối thi / Năng khiếu: V00 (Toán-Lý-Vẽ), H00 (Văn-Năng khiếu 1-Năng khiếu 2), D01, C00.\n"
              "🏫 Top Trường Đại học tại Việt Nam: ĐH Kiến trúc (Hà Nội/TP.HCM), ĐH Mỹ thuật Công nghiệp, Học viện Báo chí & Tuyên truyền, ĐH RMIT.\n"
              "💡 Ngành Hot: Thiết kế Đồ họa, Truyền thông đa phương tiện, Quan hệ công chúng (PR), Sáng tạo nội dung.\n\n"
              "🚀 Lời khuyên THPT: Xây dựng Portfolio cá nhân và nâng cao tư duy thẩm mỹ ứng dụng!"
            : "🎨 Arts, Design & Media Field:\n\n"
              "📊 Estimated Match Rating: 85% - 92% (Recommended for creative & aesthetic-minded students)\n"
              "📚 Subject & Aptitude Combos: V00, H00, D01, C00.\n"
              "🏫 Top Universities in Vietnam: Univ of Architecture, Industrial Fine Arts Univ, Academy of Journalism & Communication.\n"
              "💡 Top Careers: Graphic Designer, Multimedia Specialist, Content Creator, PR Strategist.\n\n"
              "🚀 High School Tip: Build a mini portfolio of your creative works!",
        followUps: isVi
            ? [
                "Học Thiết kế đồ họa có cần giỏi vẽ tay không?",
                "Truyền thông đa phương tiện thi khối nào?",
                "Cơ hội việc làm ngành Content Creator?"
              ]
            : [
                "Do I need drawing skills for Graphic Design?",
                "Which subject tracks apply for Multimedia Media?",
                "Career prospects for Content Creators?"
              ],
      );
    }

    // Default friendly orientation response
    final randomResponsesVi = [
      "Cảm ơn câu hỏi của bạn! Với tư vấn hướng nghiệp THPT, chúng ta sẽ phân tích dựa trên: (1) Chỉ số phù hợp % - (2) Tổ hợp khối thi THPT (A00, A01, D01...) - (3) Danh sách các trường Đại học hàng đầu Việt Nam. Bạn đang quan tâm đến ngành hay môn học sở trường nào?",
      "Để đánh giá % phù hợp chính xác nhất, bạn có thể chia sẻ thông tin lớp học (10, 11 hay 12) và môn học tự tin nhất (Toán, Văn, Anh, Lý, Hóa, Sinh...) không?",
      "Chào bạn! Bạn có thể hỏi mình bất kỳ câu hỏi nào về chọn ngành, khối thi A00-D01 hay bài test tính cách RIASEC để mình đưa ra phân tích chi tiết nhé!"
    ];

    final randomResponsesEn = [
      "Great to connect! For high school career counseling, we assess: (1) Match Rating % - (2) Exam Combos (A00, A01, D01...) - (3) Top Vietnamese Universities. Which major or subject track are you interested in?",
      "To calculate your major compatibility score, could you share your grade (10, 11, or 12) and favorite high school subjects?",
      "Welcome! Feel free to ask about any major, subject combination, or RIASEC personality test to get detailed advice!"
    ];

    final responses = isVi ? randomResponsesVi : randomResponsesEn;
    return CareerBotResult(
      category: 'General',
      text: responses[Random().nextInt(responses.length)],
      followUps: isVi
          ? [
              "Tôi muốn làm trắc nghiệm RIASEC",
              "Tư vấn chọn khối thi lớp 10, 11",
              "Khối ngành Công nghệ thông tin"
            ]
          : [
              "I want to take RIASEC test",
              "Advice for Grade 10-11 subject selection",
              "Information Technology Careers"
            ],
    );
  }
}
