//
//  SupportView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 28/06/2023.
//

import SwiftUI

struct SupportView: View {
    
    @State var isFirst: Bool = true
    @State var openSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            if isFirst{
                HStack{
                    Text("Support Groups")
                        .font(.custom("EBGaramond-Regular", size: 40))
                    Spacer()
                }
                Text("This is a safe and welcoming space where individuals facing similar challenges can come together to share their experiences, provide mutual support, and offer guidance to one another. It's a community of understanding and empathy, where you can connect with others who can relate to what you're going through.")
                    .font(.custom("EBGaramond-Regular", size: 20))
                    .padding(.top, 10)
                
                Button(action:{
                    openSheet = true
                }){
                    Text("Learn about the benefits of support group")
                        .font(.custom("EBGaramond-Regular", size: 20))
                        .padding(.top, 10)
                }
            }
            Spacer()
            Rectangle()
                .cornerRadius(5)
                .offset(x: 4, y: 4)
                .frame(height: 100)
                .overlay(
                    Rectangle()
                        .stroke(.gray, lineWidth: 5)
                        .background(.black)
                        .cornerRadius(5)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Get Started")
                                        .font(.custom("EBGaramond-Regular", size: 20))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.white)
                            }
                                .onTapGesture {
                                    
                                }
                                .padding()
                        )
                )
                .padding()
        }
        .sheet(isPresented: $openSheet) {
            SupportSheet()
                .padding()
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportSheet()
    }
}

struct SupportSheet: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Why should I join a support group?")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top, 10)
                
                Text("Joining a support group can have numerous benefits. It provides a sense of belonging and validation, knowing that you're not alone in your struggles. It offers an opportunity to gain different perspectives, learn coping strategies, and receive emotional support from people who truly understand. Support groups can be empowering and foster personal growth as you navigate your journey towards better mental well-being.")
                    .font(.custom("EBGaramond-Regular", size: 18))
                    .padding(.top, 10)
                
                Text("Confidentiality and Trust")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top, 10)
                
                Text("Support groups emphasize confidentiality and trust. What is shared within the group remains confidential, creating a safe space for open and honest discussions. Trust is fostered, allowing participants to share their thoughts, feelings, and experiences without fear of judgment or breach of privacy")
                    .font(.custom("EBGaramond-Regular", size: 18))
                    .padding(.top, 10)
                
                Text("Group Facilitation")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top, 10)
                
                Text("Support groups are often facilitated by trained professionals or individuals with lived experiences who provide guidance and ensure that the group remains focused and supportive. Facilitators help maintain a respectful environment, encourage participation, and offer valuable insights and resources.")
                    .font(.custom("EBGaramond-Regular", size: 18))
                    .padding(.top, 10)
                
                Text("Different Types of Support Groups")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top, 10)
                
                Text("Support groups cater to various mental health concerns, such as depression, anxiety, addiction recovery, grief, LGBTQ+ support, parenting challenges, and more. There are also specialized groups for specific demographics or shared experiences, ensuring that you can find a support group tailored to your needs.")
                    .font(.custom("EBGaramond-Regular", size: 18))
                    .padding(.top, 10)
                
                Text("How to Find a Support Group")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top, 10)
                
                Text("To find a support group, you can explore local mental health organizations, community centers, or online platforms dedicated to mental health. Reach out to therapists, counselors, or helplines for recommendations. Additionally, there are online forums and social media groups where you can connect with people who share similar experiences.")
                    .font(.custom("EBGaramond-Regular", size: 18))
                    .padding(.top, 10)
            }
        }
    }
}
