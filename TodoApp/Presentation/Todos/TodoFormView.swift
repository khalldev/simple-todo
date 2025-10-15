import SwiftUI

struct TodoFormView: View {
  @Binding var title: String
  @Binding var description: String
  @Binding var emoji: String

  @StateObject private var geminiService = GeminiService()
  @State private var showEmojiPicker = false
  private let suggestions = ["Plan a trip to beach 🏖️", "Finish SwiftUI project 👨‍💻", "Read a book 📚", "Go for a run 🏃‍♀️"]

  private let markdown = """
  Tentu, dengan senang hati! Saya akan bantu terjemahkan kalimat \"saya juga kurang tau\" ke dalam bahasa Inggris dengan beberapa pilihan, dari yang paling umum hingga yang lebih formal, beserta penjelasannya.\n\nKalimat \"saya juga kurang tau\" punya dua makna utama:\n1.  **Kurang tahu** (tidak yakin, tidak punya informasi lengkap).\n2.  **Juga** (orang lain juga tidak tahu, atau ini menambah informasi sebelumnya).\n\nBerikut adalah terjemahan terbaik berdasarkan konteksnya:\n\n---\n\n### Pilihan 1: Paling Umum dan Alami (Santai)\n\nIni adalah pilihan yang paling sering digunakan dalam percakapan sehari-hari.\n\n**\"I'm not sure either.\"**\n\n*   **Penjelasan:**\n    *   **\"I'm not sure\"** adalah terjemahan yang paling pas untuk \"kurang tau\". Ini lebih halus dan sopan daripada \"I don't know\".\n    *   **\"either\"** adalah kata yang tepat untuk \"juga\" dalam kalimat negatif (contoh: \"I don't like it.\" -> \"I don't like it **either**.\").\n*   **Kapan pakai:** Saat teman kamu bertanya sesuatu dan kamu juga tidak tahu jawabannya, sama seperti dia.\n\n---\n\n### Pilihan 2: Sedikit Lebih Formal / Netral\n\nIni pilihan yang baik untuk percakapan standar, misalnya dengan rekan kerja atau orang yang tidak terlalu akrab.\n\n**\"I'm not entirely sure.\"**\n\n*   **Penjelasan:**\n    *   **\"not entirely sure\"** artinya \"tidak sepenuhnya yakin\". Ini sangat pas untuk makna \"kurang\" tau, artinya kamu mungkin tahu sedikit, tapi tidak lengkap.\n    *   Kata \"juga\" di sini tersirat dari konteks percakapan. Jika perlu menekankan \"juga\", kamu bisa bilang: **\"I'm not entirely sure either.\"**\n*   **Kapan pakai:** Saat dalam rapat atau diskusi ketika kamu diminta pendapat, tapi informasimu masih terbatas.\n\n---\n\n### Pilihan 3: Langsung dan Jelas\n\nIni adalah terjemahan yang paling lurus dari \"saya tidak tahu\".\n\n**\"I don't know either.\"**\n\n*   **Penjelasan:**\n    *   **\"I don't know\"** adalah cara paling langsung untuk mengatakan \"saya tidak tahu\".\n    *   **\"either\"** digunakan lagi untuk kata \"juga\".\n*   **Kapan pakai:** Saat kamu ingin memberikan jawaban yang tegas bahwa kamu memang tidak memiliki informasi sama sekali. Ini sedikit lebih \"blak-blakan\" dibanding \"I'm not sure\".\n\n---\n\n### Ringkasan & Cara Memilih\n\n| Kalimat Bahasa Inggris       | Nuansa / Kapan Dipakai                                   |\n| ---------------------------- | -------------------------------------------------------- |\n| **I'm not sure either.**     | **Paling direkomendasikan.** Santai, sopan, dan alami.   |\n| **I'm not entirely sure.**   | Sedikit lebih formal, menekankan bahwa kamu kurang info.  |\n| **I don't know either.**     | Langsung dan jelas, tapi bisa terdengar sedikit keras.   |\n| **I'm not too sure either.** | Alternatif lain yang mirip dengan \"I'm not sure either\". |\n\n### Tambahan: Cara Pengucapan (Pronunciation)\n\nUntuk membantumu, ini adalah cara kira-kira pengucapannya:\n\n1.  **I'm not sure either.**\n    *   Dibaca: **\"aim nat syur ei-der\"**\n    *   `either` bisa diucapkan \"ei-der\" (seperti dalam kata \"eight\") atau \"ai-der\" (seperti dalam kata \"ice\"). Keduanya benar.\n\n2.  **I'm not entirely sure.**\n    *   Dibaca: **\"aim nat in-tai-ruh-li syur\"**\n    *   Fokus pada suku kata `en-tai-re-ly`.\n\n3.  **I don't know either.**\n    *   Dibaca: **\"ai dont nou ei-der\"**\n\n**Tips Tambahan untuk Memperbaiki Grammar:**\n*   **Perhatikan \"either\" vs. \"too\":**\n    *   Gunakan **either** untuk kalimat negatif (I don't know, I'm not sure).\n    *   Gunakan **too** untuk kalimat positif (I like it, I want to go).\n    *   Contoh: \"I like coffee.\" -> \"I like coffee **too**.\"\n*   **Banyak Dengar dan Tiru:** Coba tonton film atau serial dalam bahasa Inggris dengan subtitle. Perhatikan bagaimana karakter menggunakan kalimat-kalimat ini dalam percakapan.\n\nSemoga ini membantu ya! Terus berlatih dan jangan takut untuk membuat kesalahan. Itu adalah bagian dari proses belajar.
  """

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        ZStack(alignment: .topLeading) {
          if title.isEmpty {
            SuggestionTypingView(suggestions: suggestions)
              .padding(.leading, 5)
              .padding(.top, 12)
          }
          VStack {
            HStack {
              TextField("", text: $title, axis: .vertical)
                .lineLimit(1 ... 8)
              Button(action: {
                showEmojiPicker.toggle()
              }) {
                Text(emoji.isEmpty ? "😀" : emoji)
                  .font(.largeTitle)
                  .glassEffect()
              }
              .glassEffect(in: .rect(cornerRadius: 16))
            }
          }
        }
        .textInputAutocapitalization(.none)
        .disableAutocorrection(true)
        .padding(.horizontal, 12)
        .padding(.vertical, 0)
        .cornerRadius(10)
        .padding()
        .font(.customBody)
        .glassEffect(in: .rect(cornerRadius: 16))
      }

      Text(.init(markdown))
        .contentTransition(.numericText())
        .multilineTextAlignment(.leading)
        .lineSpacing(10)
        .animation(.spring(), value: geminiService.generatedDescription)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(minHeight: 72)
        .cornerRadius(10)
        .font(.customBody)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
          if !title.isEmpty {
            Button(action: {
              geminiService.generateDescription(for: title)
            }) {
              if geminiService.isGenerating {
                ProgressView()
                  .padding(10)
              } else {
                Image(systemName: "sparkles")
                  .font(.system(size: 24))
                  .padding(10)
              }
            }
            .disabled(title.isEmpty || geminiService.isGenerating)
            .glassEffect(in: .rect(cornerRadius: 200))
            .padding()
          }
        }
        .glassEffect(in: .rect(cornerRadius: 16))
        .padding(.top, 16)
        .onChange(of: geminiService.generatedDescription) {
          description = geminiService.generatedDescription
        }
        .onAppear {
          geminiService.generatedDescription = description
        }

      Spacer()
    }
    .sheet(isPresented: $showEmojiPicker) {
      EmojiPicker(selectedEmoji: $emoji)
        .presentationDetents([.height(600)])
    }
  }
}
