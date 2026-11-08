using System;
using System.Collections.Generic;
using MediatR;
using PricingService.Api.Commands.Dto;

namespace PricingService.Api.Commands;

public class CalculatePriceCommand : IRequest<CalculatePriceResult>
{
    public string ProductCode { get; set; }
    public DateTime PolicyFrom { get; set; }
    public DateTime PolicyTo { get; set; }
    public IList<string> SelectedCovers { get; set; } = new List<string>();
    public List<QuestionAnswer> Answers { get; set; } = new List<QuestionAnswer>();
}
