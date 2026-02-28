import SwiftUI

struct SplashView: View {
    // Controla quando a splash screen termina
    @State private var isActive = false
    
    // Estados para as animações
    @State private var iconScale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var progress: CGFloat = 0.0

    var body: some View {
        if isActive {
            // Quando a animação acabar, chama a view principal do seu app
            ContentView()
        } else {
            GeometryReader { geo in
                ZStack {
                    // Fundo da tela
                    Color(uiColor: .systemBackground).ignoresSafeArea()
                    
                    // Verifica a orientação atual
                    let isLandscape = geo.size.width > geo.size.height
                    
                    // Adapta o layout perfeitamente para landscape, mantendo segurança para vertical
                    let layout = isLandscape ? AnyLayout(HStackLayout(spacing: 50)) : AnyLayout(VStackLayout(spacing: 30))
                    
                    layout {
                        // Mascote
                        Text("🐶")
                            .font(.system(size: isLandscape ? 140 : 120))
                            .scaleEffect(iconScale)
                            .opacity(opacity)
                        
                        // Textos e Barra de Progresso
                        VStack(alignment: isLandscape ? .leading : .center, spacing: 16) {
                            Text("OOP Quest")
                                .font(.system(size: isLandscape ? 64 : 52, weight: .heavy, design: .monospaced))
                                .foregroundStyle(Color.appPrimary)
                            
                            Text("Mastering Objects & Classes")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            // Barra de loading animada
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.appFill)
                                    .frame(height: 10)
                                
                                Capsule()
                                    .fill(Color.appPrimary)
                                    .frame(width: (isLandscape ? 300 : 250) * progress, height: 10)
                            }
                            .frame(width: isLandscape ? 300 : 250)
                            .padding(.top, 20)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onAppear {
                // Dispara as animações de entrada
                withAnimation(.easeOut(duration: 1.2)) {
                    self.iconScale = 1.0
                    self.opacity = 1.0
                }
                
                // Preenche a barra de progresso
                withAnimation(.easeInOut(duration: 2.0)) {
                    self.progress = 1.0
                }
                
                // Aguarda 2.5 segundos e transita para o app
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
