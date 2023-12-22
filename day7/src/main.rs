mod camel;

use std::cmp::Ordering;

use crate::camel::{figure::Figure, hand::Hand};

fn main() {
    let lines = include_str!("./input2.txt")
        .replace("\r\n", "\n");
    let lines = lines
        .split('\n');

    let mut hands: Vec<_> = lines
        .map(|line| {
            let hand_str = &line[0..5];
            let cards: [Figure; 5] = hand_str
                .chars()
                .map(Figure::new)
                .collect::<Vec<_>>()
                .try_into()
                .unwrap();

            let bid_str = &line[6..];
            let bid: u32 = bid_str.parse().unwrap();

            Hand::new(cards, bid)
        })
        .collect();

    hands
        .sort_by(|l, r| {
            match l.hand_type.partial_cmp(&r.hand_type) {
                Some(ordering) => match ordering {
                    Ordering::Equal => {
                        let first_not_equal_cards = l.cards
                            .iter()
                            .zip(&r.cards)
                            .find(|(lc, rc)| *lc != *rc);

                        match first_not_equal_cards {
                            Some((lc, rc)) => lc.partial_cmp(rc).unwrap(),
                            None => Ordering::Equal,
                        }
                    },
                    greater_or_less => greater_or_less,
                },
                None => todo!("handle None arm of hand type partial compare"),
            }

        });

    for hand in &hands {
        println!("{:?}", hand);
    }

    let total_winnings = hands
        .iter()
        .enumerate()
        .map(|(index, hand)| ((index + 1) as u32) * hand.bid)
        .sum::<u32>();

    println!("{total_winnings}");
}
