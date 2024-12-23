-- Configuração global de atributos e multiplicadores
AttributesConfig = {
    -- Multiplicadores por raridade
    rarityMultipliers = {
        common = 1.0,
        rare = 2.0,
        epic = 3.0,
        legendary = 4.0
    },

    -- Lista de atributos possíveis
    possibleAttributes = {
        {
            name = "power",
            min = 3,
            max = 15,
            description = "Increases damage"
        },
        {
            name = "lifesteal",
            min = 2,
            max = 10,
            description = "Converts damage to health"
        },
        {
            name = "health",
            min = 30,
            max = 150,
            description = "Increases max health"
        },
        {
            name = "speed",
            min = 5,
            max = 30,
            description = "Increases movement speed"
        },
        {
            name = "protect",
            min = 2,
            max = 10,
            description = "Reduces damage taken"
        },
        {
            name = "reflect",
            min = 2,
            max = 10,
            description = "Reflects damage back"
        }
    },

    -- Número de atributos por raridade
    attributeCount = {
        common = {min = 0, max = 0},
        rare = {min = 1, max = 1},
        epic = {min = 1, max = 3},
        legendary = {min = 2, max = 4}
    }
}

-- Função para calcular valor do atributo com multiplicador
function AttributesConfig.calculateValue(attributeName, baseValue, rarity)
    local multiplier = AttributesConfig.rarityMultipliers[rarity] or 1.0
    return math.floor(baseValue * multiplier)
end

-- Função para obter uma cópia da lista de atributos
function AttributesConfig.getAvailableAttributes()
    local attributes = {}
    for _, attr in ipairs(AttributesConfig.possibleAttributes) do
        table.insert(attributes, {
            name = attr.name,
            min = attr.min,
            max = attr.max,
            description = attr.description
        })
    end
    return attributes
end

return AttributesConfig 