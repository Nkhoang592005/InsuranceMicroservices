namespace PricingService.Api.Commands.Dto;

public abstract class QuestionAnswer
{
    public string QuestionCode { get; set; } = string.Empty;
}

public class TextQuestionAnswer : QuestionAnswer
{
    public string Answer { get; set; } = string.Empty;
}

public class ChoiceQuestionAnswer : QuestionAnswer
{
    public string Answer { get; set; } = string.Empty;
}

public class NumericQuestionAnswer : QuestionAnswer
{
    public decimal Answer { get; set; }
}
