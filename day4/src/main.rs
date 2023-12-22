use regex::Regex;

fn main() {
    let regex = Regex::new(r"(\d+)").unwrap();

    let score = include_str!("./input2.txt")
        .replace("\r\n", "\n")
        .split('\n')
        .map(|line| {
            let mut split = line.split('|');
            println!("{line}");
            let left = split.next().unwrap();
            println!("{left}");
            let right = split.next().unwrap();
            println!("{right}");

            let mut left_matches = regex.find_iter(left);

            let _id = left_matches.next().unwrap().as_str().parse::<u32>().unwrap();

            let winning = left_matches
                .map(|m| m.as_str().parse::<u32>().unwrap())
                .collect::<Vec<_>>();

            let picked = regex.find_iter(right)
                .map(|m| m.as_str().parse::<u32>().unwrap());

            let hits = picked
                .filter(|p| winning.iter().any(|w| *w == *p))
                .count();

            match hits {
                0 => 0,
                exp => 2_u32.pow(exp as u32 - 1)
            }
        })
        .sum::<u32>();

    println!("{score}");
}
