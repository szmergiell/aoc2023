use std::{fs, str::FromStr};
use regex::Regex;

#[derive(Debug)]
struct Map {
    dest_start: i64,
    src_start: i64,
    length: i64
}

impl FromStr for Map {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let map_numbers = collect_numbers(s);
        if map_numbers.len() != 3 {
            return Err("String does not contain 3 numbers".to_string());
        }

        Ok(Map {
            dest_start: map_numbers[0],
            src_start: map_numbers[1],
            length: map_numbers[2]
        })
    }
}

fn collect_numbers(str: &str) -> Vec<i64> {
    let regex = Regex::new(r"(\d+)")
        .expect("Regex should compile");

    return regex
        .find_iter(str)
        .map(|m| m.as_str().parse().unwrap())
        .collect();
}

fn collect_maps(str: &str) -> Vec<Map> {
    str
        .split("\r\n")
        .skip(1)
        .map(|l| l.parse().unwrap())
        .collect()
}

fn get_dest_value(src: &i64, maps: &[Map]) -> i64 {
    maps
        .iter()
        .find_map(|m| {
            if *src >= m.src_start && *src < m.src_start + m.length {
                Some(m.dest_start + (*src - m.src_start))
            } else {
                None
            }
        })
        .unwrap_or(*src)
}

fn main() {
    let input = fs::read_to_string("./input2.txt")
        .expect("Should have been able to read the file");

    let paragraphs: Vec<&str>  = input.split("\r\n\r\n").collect();

    let seeds = collect_numbers(paragraphs[0]);

    let seed_to_soil = collect_maps(paragraphs[1]);
    let soil_to_fertilizer = collect_maps(paragraphs[2]);
    let fertilizer_to_water = collect_maps(paragraphs[3]);
    let water_to_light = collect_maps(paragraphs[4]);
    let light_to_temperature = collect_maps(paragraphs[5]);
    let temperature_to_humidity = collect_maps(paragraphs[6]);
    let humidity_to_location = collect_maps(paragraphs[7]);

    let locations: Vec<(&i64, i64)> = seeds
        .iter()
        .map(|seed| {
            let soil = get_dest_value(seed, &seed_to_soil);
            let fertilizer = get_dest_value(&soil, &soil_to_fertilizer);
            let water = get_dest_value(&fertilizer, &fertilizer_to_water);
            let light = get_dest_value(&water, &water_to_light);
            let temperature = get_dest_value(&light, &light_to_temperature);
            let humidity = get_dest_value(&temperature, &temperature_to_humidity);
            let location = get_dest_value(&humidity, &humidity_to_location);
            println!("Seed {seed}, soil {soil}, fertilizer {fertilizer}, water {water}, light {light}, temperature {temperature}, humidity {humidity}, location {location}.");
            (seed, location)
        })
        .collect();

    println!("{:?}", locations);

    let (seed, location) = locations
        .iter()
        .min()
        .unwrap();

    println!("Shortest path - seed: {:?}, location: {:?}", seed, location);
}

