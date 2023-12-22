use std::collections::HashMap;

use super::figure::Figure;

#[derive(Debug, PartialEq, PartialOrd)]
pub enum HandType {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

impl HandType {
    pub fn new(cards: &[Figure; 5]) -> HandType {
        let mut counter: HashMap<&Figure, u32> = HashMap::new();
        for figure in cards {
            let updated_count = match counter.get(figure) {
                Some(v) => v + 1,
                None => 1
            };
            counter.insert(figure, updated_count);
        }

        if counter.values().any(|c| *c == 5) {
            return HandType::FiveOfAKind;
        }

        if counter.values().any(|c| *c == 4) {
            return HandType::FourOfAKind;
        }

        if counter.values().any(|c| *c == 2) &&
           counter.values().any(|c| *c == 3) {
            return HandType::FullHouse;
        }

        if counter.values().any(|c| *c == 3) {
            return HandType::ThreeOfAKind;
        }

        if counter.values().filter(|c| **c == 2).count() == 2 {
            return HandType::TwoPair;
        }

        if counter.values().any(|c| *c == 2) {
            return HandType::OnePair;
        }

        HandType::HighCard
    }
}