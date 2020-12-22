module Day21

export get_inputs, get_solution1, get_solution2

using UnPack: @unpack


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_input(IOBuffer("""
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
        """))
    test_output1 = 5
    test_output2 = "mxmxvkd,sqjhc,fvjkl"
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

read_input(io) = assess_foods(parse_line.(readlines(io)))

function parse_line(line)
    ingredients, allergens = split(line, r" \(contains |\)", keepempty=false)
    ingredients = Symbol.(split(ingredients, " ", keepempty=false))
    allergens = Symbol.(split(allergens, ", ", keepempty=false))
    return (; ingredients, allergens)
end

function item_dict(foods, property)
    all_of_type = unique(mapreduce(food->getfield(food, property), vcat, foods))
    type_dict = Dict(
        map(all_of_type) do item
            item=>[i for (i, food) in enumerate(foods) if item in getfield(food, property)]
        end
    )
    return type_dict, all_of_type
end

function assess_foods(foods)
    ingredient_dict, all_ingredients = item_dict(foods, :ingredients)
    allergen_dict, all_allergens = item_dict(foods, :allergens)

    allergen_to_possible_ingredient = Dict(
        map(all_allergens) do allergen
            allergen => [
                ingredient
                for (ingredient, i_inds) in ingredient_dict
                if all(idx in i_inds for idx in allergen_dict[allergen])
            ]
        end
    )

    allergenic_ingredients = Set{Symbol}()
    for allergen in all_allergens, ingredient in allergen_to_possible_ingredient[allergen]
        push!(allergenic_ingredients, ingredient)
    end
    nonallergenic_ingredients = setdiff(all_ingredients, allergenic_ingredients)
    
    return (;
        all_ingredients,
        all_allergens,
        ingredient_dict,
        allergen_dict,
        allergen_to_possible_ingredient,
        allergenic_ingredients,
        nonallergenic_ingredients,
    )
end


## Solution functions
# Part 1
function get_solution1(data)
    @unpack ingredient_dict, nonallergenic_ingredients = deepcopy(data)
    return sum(length(ingredient_dict[ingredient]) for ingredient in nonallergenic_ingredients)
end

# Part 2
function get_solution2(data)
    @unpack allergen_to_possible_ingredient = deepcopy(data)
    allergen_to_possible_ingredient = collect(pairs(allergen_to_possible_ingredient))
    allergen_to_ingredient = Pair{Symbol,Symbol}[]

    while !isempty(allergen_to_possible_ingredient)
        sort!(allergen_to_possible_ingredient, by=i->length(last(i)))
        allergen, possible_ingredients = popfirst!(allergen_to_possible_ingredient)
        ingredient = only(possible_ingredients)
        push!(allergen_to_ingredient, allergen=>ingredient)
        for ingredients in last.(allergen_to_possible_ingredient)
            filter!(i -> i != ingredient, ingredients)
        end
    end

    sort!(allergen_to_ingredient, by=first)
    return join(last.(allergen_to_ingredient), ",")
end

end