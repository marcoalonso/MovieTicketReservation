//
//  Tickets.swift
//  Movie Booking Reservation
//
//  Created by Marco Alonso Rodriguez on 31/03/23.
//

import SwiftUI

struct Tickets: View {
    
    @State  var tickets: [TicketModel] = [
        TicketModel(image: "thor", title: "Thor", subtitle: "Love and Thunder", top: "thor-top", bottom: "thor-bottom"),
        TicketModel(image: "panther", title: "Black Panther", subtitle: "Wakanda Forever", top: "panther-top", bottom: "panther-bottom"),
        TicketModel(image: "scarlet", title: "Doctor Strange", subtitle: "in the Multiverse of Madness", top: "scarlet-top", bottom: "scarlet-bottom")
    ]
    
    var body: some View {
        ZStack {
            ForEach(tickets) { ticket in
                InfiniteStackView(tickets: $tickets, ticket: ticket)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct InfiniteStackView: View {
    @Binding var tickets : [TicketModel]
    var ticket : TicketModel
    
    @GestureState var isDraging: Bool = false
    @State var offset :CGFloat = .zero
    
    @State var height: CGFloat = 0
    
    var body: some View {
        VStack {
            Ticket(title: ticket.title, subtitle: ticket.subtitle, top: ticket.top, bottom: ticket.bottom, height: $height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zIndex( getIndex() == 0 && offset > 100 ? Double(CGFloat(tickets.count) - getIndex()) - 1 : Double(CGFloat(tickets.count) - getIndex()))
        /// Rotate to left or right a little bit when slides one side
        .rotationEffect(.init(degrees: getRotation(angle: 15)))
        .rotationEffect(getIndex() == 1 ? .degrees(-6) : .degrees(0))
        .rotationEffect(getIndex() == 2 ? .degrees(6) : .degrees(0))
        .scaleEffect(getIndex() == 0 ? 1 : 0.9)
        .offset(x: getIndex() == 1 ? -40 : 0)
        .offset(x: getIndex() == 2 ? 40 : 0)
        .offset(x: offset)
        .gesture(
        DragGesture()
            .updating($isDraging, body: { _, out, _ in
                out = true
            })
            .onChanged({ value in
                var traslation = value.translation.width
                traslation = tickets.first?.id == ticket.id ? traslation : 0
                traslation = isDraging ? traslation : 0
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    offset = traslation
                    height = -offset / 5
                }
            })
            .onEnded({ value in
                let width = UIScreen.main.bounds.width
                let swipedRight = offset > (width / 2)
                let swipedLeft = -offset > (width / 2)
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    if swipedLeft {
                        offset = -width
                        removeTicket()
                    } else {
                        if swipedRight {
                            offset = width
                            removeAndAdd()
                        } else {
                            offset = .zero
                            height = .zero
                        }
                    }
                }///Animation
            })/// OnEnded
        )///- Gesture
    }///body
    
    func getIndex() -> CGFloat {
        let index = tickets.firstIndex { ticket in
            return self.ticket.id == ticket.id
        } ?? 0
        return CGFloat(index)
    }
    
    func getRotation(angle: Double) -> Double {
        let width = UIScreen.main.bounds.width
        let progress = offset / width
        
        return Double(progress * angle)
    }
    
    func removeAndAdd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var updatedTicket = ticket
            updatedTicket.id = UUID().uuidString
            
            tickets.append(updatedTicket)
            
            withAnimation(.spring()) {
                tickets.removeFirst()
            }
        }
    }
    
    func removeTicket() {
        withAnimation(.spring()) {
            tickets.removeFirst()
        }
    }
    
    ///Continuar en min 25:30
    /// https://www.youtube.com/watch?v=EkcKeGQm3_U&t=166s
    
}

struct Tickets_Previews: PreviewProvider {
    static var previews: some View {
        Tickets()
    }
}
