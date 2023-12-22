#[derive(Debug, Eq, Hash, PartialEq, PartialOrd)]
pub enum Figure {
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    T,
    J,
    Q,
    K,
    A
}

impl Figure {
    pub fn new(c: char) -> Self {
        match c {
            '2' => Figure::Two,
            '3' => Figure::Three,
            '4' => Figure::Four,
            '5' => Figure::Five,
            '6' => Figure::Six,
            '7' => Figure::Seven,
            '8' => Figure::Eight,
            '9' => Figure::Nine,
            'T' => Figure::T,
            'J' => Figure::J,
            'Q' => Figure::Q,
            'K' => Figure::K,
            'A' => Figure::A,
            _ => todo!("handle invalid character")
        }
    }
}