using MediatR;
using PolicyService.Api.Commands.Dtos;

namespace PolicyService.Api.Events;

public class PolicyCreated : INotification
{
    public string PolicyNumber { get; set; } = string.Empty;
    public PersonDto PolicyHolder { get; set; } = new();
}
