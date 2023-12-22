use super::figure::Figure;
use super::hand_type::HandType;

#[derive(Debug)]
pub struct Hand {
    pub cards: [Figure; 5],
    pub bid: u32,
    pub hand_type: HandType,
}

impl Hand {
    pub fn new(cards: [Figure; 5], bid: u32) -> Self {
        let hand_type = HandType::new(&cards);
        Hand {
            cards,
            bid,
            hand_type 
        }
    }
}